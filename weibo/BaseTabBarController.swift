//
//  BaseTabBarController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(RGB: 0xfd6e37)], forState: UIControlState.Selected)
        self.tabBar.tintColor = UIColor.init(RGB: 0xfd6e37)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
//        let vc = (self.childViewControllers.first as! UINavigationController).childViewControllers.first!
//        vc.presentViewController(loginVC!, animated: true, completion: nil)
    }
}
