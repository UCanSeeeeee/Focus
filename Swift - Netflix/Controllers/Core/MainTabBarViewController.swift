//
//  ViewController.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import Kingfisher
import SnapKit


class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: DownloadsViewController())
        let vc4 = UINavigationController(rootViewController: BNMainViewController())
        viewControllers = [vc1, vc2, vc3, vc4]
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "star")
        vc4.tabBarItem.image = UIImage(systemName: "play.circle")
        
        vc1.title = "首页"
        vc2.title = "搜索"
        vc3.title = "收藏"
        vc4.title = "只看你想看"
        
        tabBar.tintColor = .label // 蓝色和白色的差别
    }
}

// 测试重命名仓库
