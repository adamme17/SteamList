//
//  CoreDataManager.swift
//  SteamList
//
//  Created by Adam Bokun on 1.12.21.
//

import Foundation
import CoreData

class CoreDataManager: NSObject, StoreManagerProtocol {
    
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    private override init() {
        super.init()
        applicationLibraryDirectory()
        privateMOC.parent = managedObjectContext
    }
    
    private lazy var storeQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Store queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    static let sharedConst = CoreDataManager()
    
    class func shared() -> CoreDataManager {
        return sharedConst
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    internal func applicationLibraryDirectory() {
        print(applicationDocumentsDirectory)
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    // MARK: - Core Data stack
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "GameListDB", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "GameListDB.sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        print(persistentStoreURL)
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                      NSMigratePersistentStoresAutomaticallyOption : true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()
    
    func prepare(dataForSaving: [Games]) {
        _ = dataForSaving.map {self.createEntityFrom(games: $0)}
        saveData()
    }
    
    func prepareDetails(dataForSaving: [Details]) {
        _ = dataForSaving.map {
            self.createDetailsEntityFrom(details: $0)
            self.prepareScreens(dataForSaving: $0)
            self.prepareGenres(dataForSaving: $0)
        }
        saveData()
    }
    
    func prepareFavorites(dataForSaving: [Details]) {
        _ = dataForSaving.map {self.createFavoritesEntityFrom(details: $0)}
        saveData()
    }
    
    func prepareFavorites(dataForSaving: [Games]) {
        _ = dataForSaving.map {self.createFavoritesEntityFrom(game: $0)}
        saveData()
    }
    
    func prepareGenres(dataForSaving: Details) {
        _ = dataForSaving.genres?.compactMap {self.createGenereDescriptionFrom(genre: $0, appid: dataForSaving.steamAppid ?? 0)}
        saveData()
    }
    
    func prepareScreens(dataForSaving: Details) {
        _ = dataForSaving.screenshots?.compactMap {self.createScreensFrom(screen: $0, appid: dataForSaving.steamAppid ?? 0)}
        saveData()
    }
    
    internal func createEntityFrom(games: Games) -> GameItems? {
        let gameItem = GameItems(context: self.managedObjectContext)
        gameItem.appid = games.appid
        gameItem.name = games.name
        gameItem.isFavorite = games.isFavorite
        
        return gameItem
    }
    
    internal func createDetailsEntityFrom(details: Details) -> GameDetails? {
        let gameDetails = GameDetails(context: self.managedObjectContext)
        gameDetails.comingSoon = details.releaseDate?.comingSoon ?? false
        gameDetails.isFree = details.isFree ?? false
        gameDetails.linux = details.platforms?.linux ?? false
        gameDetails.mac = details.platforms?.mac ?? false
        gameDetails.windows = details.platforms?.windows ?? false
        gameDetails.date = details.releaseDate?.date ?? ""
        gameDetails.finalFormatted = details.priceOverview?.finalFormatted
        //        gameDetails.genreDescription = details.genres?.description
        gameDetails.headerImage = details.headerImage
        gameDetails.name = details.name
        gameDetails.shortDescript = details.shortDescript
        gameDetails.type = details.type
        gameDetails.discountPercent = Int64(details.priceOverview?.discountPercent ?? 0)
        gameDetails.steamAppid = Int64(details.steamAppid ?? 0)
        
        return gameDetails
    }
    
    func createGenereDescriptionFrom(genre: Genre, appid: Int) -> Genres? {
        let genres = Genres(context: self.managedObjectContext)
        genres.appid = Int64(appid)
        genres.genreid = Int64(genre.id ?? "") ?? 0
        genres.genreDescription = genre.genreDescription ?? ""
        
        return genres
    }
    
    func createScreensFrom(screen: Screenshot, appid: Int) -> Screens? {
        let screens = Screens(context: self.managedObjectContext)
        screens.appid = Int64(appid)
        screens.screenid = Int64(screen.id ?? 0)
        screens.pathFull = screen.pathFull ?? ""
        
        return screens
    }
    
    internal func createFavoritesEntityFrom(details: Details) -> FavoriteGames {
        let favorites = FavoriteGames(context: self.managedObjectContext)
        favorites.isFree = details.isFree ?? false
        favorites.finalFormatted = details.priceOverview?.finalFormatted
        favorites.name = details.name
        favorites.discountPercent = Int64(details.priceOverview?.discountPercent ?? 0)
        favorites.id = Int64(details.steamAppid ?? 0)
        
        return favorites
    }
    
    internal func createFavoritesEntityFrom(game: Games) -> FavoriteGames {
        let favorites = FavoriteGames(context: self.managedObjectContext)
        favorites.isFree = false
        favorites.finalFormatted = ""
        favorites.name = game.name
        favorites.discountPercent = 0
        favorites.id = Int64(game.appid)
        
        return favorites
    }
    
    func saveData() {
        
        let context = self.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllData() -> [Games] {
        var result = [Games]()
        var favorites = [FavoriteGames]()
        self.storeQueue.maxConcurrentOperationCount = 2
        let favoriteOperation = BlockOperation {
            let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                favorites += objects
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let gameOperation = BlockOperation {
            
            let fetchRequest: NSFetchRequest<GameItems> = GameItems.fetchRequest()
            do {
                
                
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { game -> Games in
                    return Games(appId: Int(game.appid),
                                 name: game.name ?? "",
                                 isFavorite: favorites.contains(where: {Int($0.id) == Int(game.appid)}))
                }
                result += fetchResult
            } catch {
                print(error.localizedDescription)
            }
        }
        gameOperation.addDependency(favoriteOperation)
        self.storeQueue.addOperations([favoriteOperation, gameOperation], waitUntilFinished: true)
        return result
    }
    
    func fetchGameDetail(id: Int) -> Details? {
        var result = [Details]()
        var screens = [Screenshot]()
        var genres = [Genre]()
        self.storeQueue.maxConcurrentOperationCount = 2
        let screensOperation = BlockOperation {
            let fetchRequest: NSFetchRequest<Screens> = Screens.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { screen -> Screenshot in
                    return Screenshot(id: Int(screen.appid),
                                      pathThumbnail: nil,
                                      pathFull: screen.pathFull ?? "")
                }
                screens += fetchResult.filter { $0.id == id }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let genresOperation = BlockOperation {
            let fetchRequest: NSFetchRequest<Genres> = Genres.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { genre -> Genre in
                    return Genre(id: String(genre.appid),
                                 genreDescription: genre.genreDescription ?? "")
                }
                genres += fetchResult.filter { Int($0.id ?? "0") == id }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let detailsOperation = BlockOperation {
            
            let fetchRequest: NSFetchRequest<GameDetails> = GameDetails.fetchRequest()
            do {
                
                
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.filter { game -> Bool in
                    return Int(game.steamAppid) == id
                }
                    .compactMap { game -> Details in
                        return Details(type: game.type,
                                       name: game.name,
                                       steamAppid: Int(game.steamAppid),
                                       requiredAge: nil,
                                       isFree: game.isFree,
                                       controllerSupport: nil,
                                       detailedDescription: nil,
                                       aboutTheGame: nil,
                                       shortDescript: game.shortDescript,
                                       supportedLanguages: nil,
                                       headerImage: game.headerImage,
                                       website: nil,
                                       legalNotice: nil,
                                       developers: nil,
                                       publishers: nil,
                                       priceOverview: Price(currency: "", initial: 0,
                                                            priceOverviewFinal: 0,
                                                            discountPercent: Int(game.discountPercent),
                                                            initialFormatted: "",
                                                            finalFormatted: game.finalFormatted ?? ""),
                                       platforms: Platforms(windows: game.windows, mac: game.mac, linux: game.linux),
                                       categories: nil,
                                       genres: genres,
                                       screenshots: screens,
                                       releaseDate: ReleaseDate(comingSoon: game.comingSoon, date: game.date),
                                       background: nil)
                    }
                result += fetchResult
            } catch {
                print(error.localizedDescription)
            }
        }
        detailsOperation.addDependency(screensOperation)
        detailsOperation.addDependency(genresOperation)
        self.storeQueue.addOperations([screensOperation, detailsOperation, genresOperation], waitUntilFinished: true)
        return result.first(where: { $0.steamAppid == id})
    }
    
    func fetchFavoritesGames() -> [Int] {
        var result = [Int]()
        self.storeQueue.addOperation {
            let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { game -> Int in
                    return Int(game.id)
                }
                result += fetchResult
            } catch {
                print(error.localizedDescription)
            }
        }
        self.storeQueue.waitUntilAllOperationsAreFinished()
        return result
    }
    
    func fetchFavoritesGamesToModel() -> [FavoriteGames] {
        var favorites = [FavoriteGames]()
        self.storeQueue.addOperation {
            let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                favorites += objects
            } catch let error {
                print(error.localizedDescription)
            }
        }
        self.storeQueue.waitUntilAllOperationsAreFinished()
        return favorites
    }
    
    func deleteItemFromFavorites(id: Int) {
        guard let favorite = fetchFavoritesGamesToModel()
                .first(where: { Int($0.id) == id })
        else { return }
        
        managedObjectContext.delete(favorite)
        saveData()
    }
    
    func storeDataAsync(data: [Games]) {
        self.storeQueue.addOperation {
            self.prepare(dataForSaving: data)
        }
    }
}
