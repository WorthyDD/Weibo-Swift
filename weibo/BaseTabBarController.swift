//
//  BaseTabBarController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

let publishMessageSBID = "PublishMessageViewController"

class BaseTabBarController: UITabBarController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(RGB: 0xfd6e37)], forState: UIControlState.Selected)
        self.tabBar.tintColor = UIColor.init(RGB: 0xfd6e37)
        let button = UIButton()
//        button.center = self.tabBar.center
        button.imageView?.layer.cornerRadius = 6
        button.imageView?.clipsToBounds = true
        button.clipsToBounds = true
        button.imageView?.backgroundColor = UIColor.greenColor()
        button.contentMode = UIViewContentMode.ScaleAspectFill
        let width = SCREEN_WIDTH/3
        button.frame = CGRectMake(SCREEN_WIDTH/2-width/2, 0, width, 50)
        button.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(didTapPublishButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        button.backgroundColor = UIColor.init(RGB: 0xfd6e37)
        self.tabBar.addSubview(button)
        
    }
    
    
    
    func didTapPublishButton(sender : UIButton){
        
        
        let alertVC = UIAlertController(title: "select photos to upload", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let camera = UIAlertAction(title: "from camera", style: UIAlertActionStyle.Default) { (action) in
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: {
                
            })

//            alertVC.dismissViewControllerAnimated(true, completion: {
//                          })
            
        }
        let album = UIAlertAction(title: "from album", style: UIAlertActionStyle.Default) { (action) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: {
                
            })

//            alertVC.dismissViewControllerAnimated(true, completion: {
//                            })

        }
        let cancleAction = UIAlertAction(title: "cancle", style: UIAlertActionStyle.Cancel) { (action) in
            
        }
        alertVC.addAction(camera)
        alertVC.addAction(album)
        alertVC.addAction(cancleAction)
        self.presentViewController(alertVC, animated: true) { 
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) {
            let publishVC = self.storyboard?.instantiateViewControllerWithIdentifier(publishMessageSBID) as! PublishMessageViewController
            self.presentViewController(publishVC, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(picker: MSImagePickerController!, didFinishPickingImage images: [AnyObject]!) {
        picker.dismissViewControllerAnimated(true) { 
            let publishVC = self.storyboard?.instantiateViewControllerWithIdentifier(publishMessageSBID) as! PublishMessageViewController
            publishVC.images = images as! [UIImage]!
            self.presentViewController(publishVC, animated: true, completion: nil)

        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true) { 
            let publishVC = self.storyboard?.instantiateViewControllerWithIdentifier(publishMessageSBID) as! PublishMessageViewController
            publishVC.images = [image]
            self.presentViewController(publishVC, animated: true, completion: nil)

        }
    }
}
