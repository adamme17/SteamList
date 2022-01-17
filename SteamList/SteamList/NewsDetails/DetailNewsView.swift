//
//  DetailNewsView.swift
//  SteamList
//
//  Created by Adam Bokun on 16.01.22.
//

import UIKit
import WebKit

final class DetailNewsView: BackgroundView {
    
    var appId = ""
    var name: String = ""
    let gameNameLabel = UILabel()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let horizontalLine = UIView()
    var scrollView = UIScrollView()
    var contentView = UIView()
    var webView = WKWebView()
    var news: Newsitem?
    
    override init() {
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.addSubview(contentView)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(horizontalLine)
        contentView.addSubview(webView)
        
        gameNameLabel.font = UIFont.systemFont(ofSize: 14)
        gameNameLabel.textAlignment = .left
        gameNameLabel.textColor = .white
        gameNameLabel.numberOfLines = 1
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.numberOfLines = 1
        
        authorLabel.font = UIFont.italicSystemFont(ofSize: 12)
        authorLabel.textAlignment = .left
        authorLabel.textColor = .white
        authorLabel.numberOfLines = 1
        
        horizontalLine.backgroundColor = .gray
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.tintColor = .white

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalToSuperview()
            make.width.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
        }
        gameNameLabel.snp.makeConstraints { (constraints) in
            constraints.height.equalTo(50)
            constraints.top.equalToSuperview().offset(5)
            constraints.leading.equalToSuperview().offset(20)
        }
        dateLabel.snp.makeConstraints { constraints in
            constraints.height.equalTo(50)
            constraints.top.equalToSuperview().offset(5)
            constraints.centerY.equalTo(gameNameLabel.snp.centerY)
            constraints.trailing.equalToSuperview().offset(-10)
        }
        authorLabel.snp.makeConstraints { (constraints) in
            constraints.height.equalTo(20)
            constraints.top.equalTo(gameNameLabel.snp.bottom).offset(5)
            constraints.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { constraints in
            constraints.height.equalTo(20)
            constraints.top.equalTo(authorLabel.snp.bottom).offset(20)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.leading.equalToSuperview().offset(20)
        }
        horizontalLine.snp.makeConstraints { constraints in
            constraints.top.equalTo(titleLabel.snp.bottom).offset(15)
            constraints.leading.equalToSuperview().offset(10)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.height.equalTo(1)
        }
        webView.snp.makeConstraints { constraints in
            constraints.top.equalTo(horizontalLine.snp.bottom).offset(20)
            constraints.leading.equalToSuperview().offset(10)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.height.equalTo(500)
            constraints.bottom.equalToSuperview()
        }
    }
    
    func getString(from date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMM, yyyy"
        let date = dateFormater.string(from: date)
        return date
    }
    
    func setupData(news: Newsitem, appId: String, gameName: String) {
        self.appId = appId
        self.name = gameName
        self.news = news
        
        self.gameNameLabel.text = gameName
        self.titleLabel.text = news.title
        self.authorLabel.text = "by \(news.author.isEmpty ? "Unknown" : news.author)"
        let date = Date(timeIntervalSince1970: Double(news.date))
        self.dateLabel.text = self.getString(from: date)
        let font = UIFont.systemFont(ofSize: 40)
        let fontName =  "-apple-system"
        let linkStyle = "<style>a:link { color: #8397D3; }</style>"
        var htmlString = "\(linkStyle)<span style=\"font-family: \(fontName); font-size: \(font.pointSize); color: #FFFFFF\">\(String(describing: news.contents))</span>"
        htmlString = htmlString.replacingOccurrences(of: "[", with: "<")
        htmlString = htmlString.replacingOccurrences(of: "]", with: ">")
        self.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
}
