//
//  HomeViewController.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import Alamofire
import MessageUI

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController, MFMailComposeViewControllerDelegate{
    private var headerView: HeroHeaderUIView?

    /// 决定了 numberOfSections 和 titleForHeaderInSection
    let sectionTitles: [String] = ["这里的都是电影热门，随便看，不踩雷", "主要是节目和电视剧", "当下最受欢迎列表", "即将到来的电影", "获得较高评分的好电影"]
    
    lazy var homeFeedTable: UITableView = {
        let tableview = UITableView()
        tableview.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    private lazy var otherResourceButton: UIButton = {
        let button = UIButton()
        button.setTitle("其他资源", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(otherResourceTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emailAuthorButton: UIButton = {
        let button = UIButton()
        button.setTitle("联系作者", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleEmailButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 创建 UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        view.addSubview(emailAuthorButton)
        view.addSubview(otherResourceButton)
        configureNavbar()
        configureHeroHeaderView()
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

//MARK: - 自定义方法
extension HomeViewController {
    /// 添加ButtonItems
    public func configureNavbar() {
        var image = UIImage(named: "tencentvqq")
        image = image?.withRenderingMode(.alwaysOriginal)
         // leftButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(openTencentTV))
         // rightButton
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "text.bubble"), style: .done, target: self, action: #selector(openChiehBlog)),
            UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(introduceTapped))
        ]
         
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func introduceTapped() {
        let alert = UIAlertController(title: "软件介绍", message: "本程序仅用于付费电影试映，所有数据来自TMDB公共Api，不向用户收费。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func openTencentTV() {
        guard let url = URL(string: "https://film.qq.com/film_all_list/allfilm.html?type=movie&sort=75") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func openChiehBlog() {
        let alert = UIAlertController(title: "作者博客", message: "你想了解更多作者的项目吗?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "当然", style: .default, handler: { _ in
            guard let url = URL(string: "https://chiehwang.top") else { return }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "才不", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleEmailButtonTapped() {
        UIView.animate(withDuration: 0.35, animations: {
            self.emailAuthorButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.35) {
                self.emailAuthorButton.transform = CGAffineTransform.identity
            }
        })
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["chieh504@qq.com"])
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "遇到了一些问题", message: "您的设备未配置邮件。请配置电子邮件帐户后重试。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func otherResourceTapped() {
        UIView.animate(withDuration: 0.35, animations: {
            self.otherResourceButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.35) {
                self.otherResourceButton.transform = CGAffineTransform.identity
            }
        })
        let alert = UIAlertController(title: "资源库", message: "电子书：https://zhelper.net\n电影片源：https://yiso.fun\nMac软件：https://www.macyy.cn", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "用户若乐意补充分享请与作者联系", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    private func applyConstraints() {
        if let headerView = headerView {
            emailAuthorButton.snp.makeConstraints { make in
                make.left.equalTo(headerView.snp.left).offset((UIScreen.main.bounds.width - 240 - 40)/2)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(130)
            }
            otherResourceButton.snp.makeConstraints { make in
                make.right.equalTo(headerView.snp.right).offset(-(UIScreen.main.bounds.width - 240 - 40)/2)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(130)
            }
        } else {
            print("headerView is nil")
        }
    }
    
    public func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                let titleViewModel = TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? "")
                self?.headerView?.configure(with: titleViewModel)
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
}


//MARK: - UITableViewDelegate + UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()

        }
        
        if indexPath.section < 3 {
            if let flowLayout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                // Set the scroll direction to vertical
                flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: 200)
                flowLayout.minimumInteritemSpacing = 0
                flowLayout.scrollDirection = .vertical
            }
        }
        
        return cell
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < 3 {
            return 600
        }
        return 200
    }
    
    // Section 的页眉高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        // capitalizeFirstLetter() 首字母大写
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    /// 点击事件 didSelectItemAt
    func collectionViewTableViewCellDidTapCell(viewModel: TitlePreviewViewModel, indexPath: IndexPath, Titles: [Title]) {
        let vc = TitlePreviewViewController()
        vc.configure(with: viewModel)
        vc.configIndexPath(configIndexPath: indexPath, Titles: Titles)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
