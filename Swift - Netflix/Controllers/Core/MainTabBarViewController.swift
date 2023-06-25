//
//  ViewController.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import UIKit
import Kingfisher
import SnapKit


class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate{

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
        vc4.title = "订阅"
        
        tabBar.tintColor = .label // 蓝色和白色的差别
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 获取当前选中的tabBarItem和将要选中的tabBarItem
        guard let oldTabBarItem = tabBarController.selectedViewController?.tabBarItem,
              let oldTabBarButton = oldTabBarItem.value(forKey: "view") as? UIView,
              let newTabBarButton = viewController.tabBarItem.value(forKey: "view") as? UIView else {
            return true
        }
        
        // 设置动画参数
        let duration: TimeInterval = 0.3 // 动画时长
        let scale: CGFloat = 1.2
        
        // 如果将要选中的tabBarItem和当前选中的tabBarItem不同，则进行动画处理
        if oldTabBarItem != viewController.tabBarItem {
            UIView.animate(withDuration: duration, animations: {
                newTabBarButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
            UIView.animate(withDuration: duration) {
                oldTabBarButton.transform = CGAffineTransform.identity
            }
        }
        // 返回true表示允许切换tabBarItem
        return true
    }
}

//UIView.animate(withDuration: duration, animations: {
//    selectedTabBarButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//})
