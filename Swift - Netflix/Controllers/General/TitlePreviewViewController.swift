//
//  TitlePreviewViewController.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import WebKit
import SwiftUI

class TitlePreviewViewController: UIViewController {
    
    private var reloadURL: URL?
    private var indexPath: IndexPath?
    private var titles: [Title] = [Title]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid!"
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(downloadTitleAt), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
        
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(overviewLabel.snp.bottom).offset(25)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
//
//        let webViewConstraints = [
//            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.heightAnchor.constraint(equalToConstant: 300)
//        ]
//
//        let titleLabelConstraints = [
//            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//        ]
//
//        let overviewLabelConstraints = [
//            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
//            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ]
//
//        let downloadButtonConstraints = [
//            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
//            downloadButton.widthAnchor.constraint(equalToConstant: 140),
//            downloadButton.heightAnchor.constraint(equalToConstant: 40)
//        ]
//
//        NSLayoutConstraint.activate(webViewConstraints)
//        NSLayoutConstraint.activate(titleLabelConstraints)
//        NSLayoutConstraint.activate(overviewLabelConstraints)
//        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    @objc func didTapRefresh() {
        webView.load(URLRequest(url: reloadURL!))
    }
    
    @objc func downloadTitleAt() {
        guard let indexPath = indexPath else {
            return
        }
        print("DownloadSucceed")
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                // 问题所在
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        reloadURL = url
        webView.load(URLRequest(url: url))
    }
    
    public func configIndexPath(configIndexPath: IndexPath, Titles: [Title]) {
        indexPath = configIndexPath
        titles = Titles
    }

}
