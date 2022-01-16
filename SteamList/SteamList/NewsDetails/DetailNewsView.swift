//
//  DetailNewsView.swift
//  SteamList
//
//  Created by Adam Bokun on 16.01.22.
//

import UIKit
import WebKit

final class DetailNewsView: BackgroundView {
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 0
        return label
    }()

    var gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    var webView: WKWebView = {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.tintColor = .white
        return webView
    }()

    var contentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    var horizontalLine: UIView = {
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = .white
        return horizontalLine
    }()

    private var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .white
        return errorLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience override init() {
        self.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupSeccessView() {
        setupScrollView()
        setupContentView()
        setupHeader()
        setupHorizontalLine()
        // setupContentLabel()
        setupWebView()
    }

    private func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { constraints in
            constraints.top.bottom.equalTo(safeAreaLayoutGuide)
            constraints.leading.trailing.equalToSuperview()
            constraints.width.equalToSuperview()
        }
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { constraints in
            constraints.centerX.width.top.bottom.equalToSuperview()
        }
    }

    private func setupHeader() {
        let containerView = UIView()
        containerView.addSubview(gameNameLabel)
        containerView.addSubview(dateLabel)

        contentView.addSubview(containerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)

        containerView.snp.makeConstraints { constraints in
            constraints.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }

        gameNameLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalToSuperview()
            constraints.leading.equalToSuperview().offset(15)
        }

        dateLabel.snp.makeConstraints { constraints in
            constraints.top.equalToSuperview().offset(10)
            constraints.centerY.equalToSuperview()
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.leading.equalTo(gameNameLabel.snp.trailing).offset(10)
            constraints.width.equalTo(gameNameLabel.snp.width).multipliedBy(0.5)
        }

        authorLabel.snp.makeConstraints { (constraints) in
            constraints.top.equalTo(containerView.snp.bottom)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.leading.equalToSuperview().offset(15)
        }

        titleLabel.snp.makeConstraints { constraints in
            constraints.top.equalTo(authorLabel.snp.bottom).offset(10)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.leading.equalToSuperview().offset(15)
        }
    }

    private func setupHorizontalLine() {
        contentView.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { constraints in
            constraints.top.equalTo(titleLabel.snp.bottom).offset(30)
            constraints.leading.equalToSuperview().offset(10)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.height.equalTo(1)
        }
    }

//    private func setupContentLabel() {
//        contentView.addSubview(contentLabel)
//        contentLabel.snp.makeConstraints { constraints in
//            constraints.top.equalTo(horizontalLine.snp.bottom).offset(20)
//            constraints.leading.equalToSuperview().offset(20)
//            constraints.trailing.equalToSuperview().offset(-20)
//            constraints.bottom.equalToSuperview()
//        }
//    }

    private func setupWebView() {
        contentView.addSubview(webView)
        webView.snp.makeConstraints { constraints in
            constraints.top.equalTo(horizontalLine.snp.bottom).offset(20)
            constraints.leading.equalToSuperview().offset(10)
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.height.equalTo(500)
            constraints.bottom.equalToSuperview()
        }
    }

    private func setupEmptyView() {
        setupErrorLabel(text: "Oops... No data here")
    }

    private func setupErrorView() {
        setupErrorLabel(text: "Oops... Something go wrong")
    }

    private func setupErrorLabel(text: String) {
        self.addSubview(errorLabel)
        errorLabel.text = text
        errorLabel.snp.makeConstraints { constraints in
            constraints.center.equalToSuperview()
        }
    }
    
}
