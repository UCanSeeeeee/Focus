//
//  HomeViewController.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import Alamofire

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController  {
    private var headerView: HeroHeaderUIView?

    /// 决定了 numberOfSections 和 titleForHeaderInSection
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    lazy var homeFeedTable: UITableView = {
        let tableview = UITableView()
        tableview.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    // 创建 UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "avc"
        navigationItem.title = "Home"
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        configureNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
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
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
         // leftButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(onTap))
         // rightButton
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(onTap)),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: #selector(onTap))
        ]
         
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func onTap() {
        print("TapSucceed")
    }
    
    /// 调用api
// 直接用AF写的效果
//        AF.request("https://api.themoviedb.org/3/trending/movie/day?api_key=697d439ac993538da4e3e60b54e762cd").responseDecodable { [weak self] (res: AFDataResponse<TrendingTitleResponse>) in
//            switch res.result {
//            case .success(let data):
//                let titles = data.results
//                let selectedTitle = titles.randomElement()
//                let titleViewModel = TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? "")
//                self?.headerView?.configure(with: titleViewModel)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
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
        // 能够传递点击事件
        cell.delegate = self
        
        // 🌸未搞懂，等待解决
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
        
        return cell
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
// 改变顶部透明度
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
//    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
    /// 点击事件 didSelectItemAt
    func collectionViewTableViewCellDidTapCell(viewModel: TitlePreviewViewModel, indexPath: IndexPath, Titles: [Title]) {

        let vc = TitlePreviewViewController()
        vc.configure(with: viewModel)
        vc.configIndexPath(configIndexPath: indexPath, Titles: Titles)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        
//        let vc = TitlePreviewViewController()
//        vc.configure(with: viewModel)
//        present(vc, animated: true)
        
//        DispatchQueue.main.async { [weak self] in
//            let vc = TitlePreviewViewController()
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
