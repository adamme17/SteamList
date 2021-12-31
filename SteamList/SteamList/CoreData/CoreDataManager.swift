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
    
    lazy var managedObjectContext = {
        
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameListDB")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func prepare(dataForSaving: [Games]) {
        _ = dataForSaving.map {self.createEntityFrom(games: $0)}
        saveData()
    }
    
    func prepareDetails(dataForSaving: [Details]) {
        _ = dataForSaving.map {self.createDetailsEntityFrom(details: $0)}
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
        gameDetails.genreDescription = details.genres?.description
        gameDetails.headerImage = details.headerImage
        gameDetails.name = details.name
        gameDetails.shortDescript = details.shortDescript
        gameDetails.type = details.type
        gameDetails.discountPercent = Int64(details.priceOverview?.discountPercent ?? 0)
        gameDetails.steamAppid = Int64(details.steamAppid ?? 0)
        
        return gameDetails
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
    
    func saveDataInBackground() {
        persistentContainer.performBackgroundTask { (context) in
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func fetchAllData() -> [Games] {
        var result = [Games]()
        self.storeQueue.addOperation { [self] in
            do {
                let fetchRequest: NSFetchRequest<GameItems>
                fetchRequest = GameItems.fetchRequest()
                
                let context = persistentContainer.viewContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { game -> Games in
                    return Games(appId: game.appid,
                                 name: game.name ?? "")
                }
                result += fetchResult
            } catch {
                print(error.localizedDescription)
            }
        }
        self.storeQueue.waitUntilAllOperationsAreFinished()
        return result
    }
    
    func fetchGameDetail(id: Int) -> [Details] {
        var result = [Details]()
        
        self.storeQueue.addOperation {
            
            let fetchRequest: NSFetchRequest<GameDetails> = GameDetails.fetchRequest()
            //            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameDetails")
            //        fetchRequest.predicate = NSPredicate(format: "steamAppid LIKE %@", id)
            do {
                
                
                let context = self.persistentContainer.viewContext
                let objects = try context.fetch(fetchRequest)
                let fetchResult = objects.compactMap { game -> Details in
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
                                   genres: [Genre(id: nil, genreDescription: game.genreDescription)],
                                   screenshots: [Screenshot(id: nil, pathThumbnail: nil, pathFull: game.pathFull)],
                                   releaseDate: ReleaseDate(comingSoon: game.comingSoon, date: game.date),
                                   background: nil)
                }
                result += fetchResult
            } catch {
                print(error.localizedDescription)
            }
        }
        self.storeQueue.waitUntilAllOperationsAreFinished()
        return result
    }
    
    func markAsFavorite(by id: Int) {
        self.storeQueue.addOperation {
            
            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameItems")
            fetchRequest.predicate = NSPredicate(format: "appid=%@", 1213750)
            do {
                if let fetchResult = try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                    if !fetchResult.isEmpty {
                        fetchResult.forEach { element in
                            element.managedObjectContext?.setValue(true, forKey: "isFavorite")
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func storeDataAsync(data: [Games]) {
        self.storeQueue.addOperation {
            self.prepare(dataForSaving: data)
        }
    }
}
