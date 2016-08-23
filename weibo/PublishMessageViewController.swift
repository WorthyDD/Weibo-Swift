//
//  PublishMessageViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class PublishMessageViewController: UIViewController {
    
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapCancle(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func didTapSend(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
