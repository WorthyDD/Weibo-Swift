//
//  ImageContainerView.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/24.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class ImageContainerView: UIView {

    
    
    func updateImageContainer(images : NSArray){
        let width = self.width/3
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        if images.count == 0{
            self.height = 0
        }
        else{
            let count = images.count
            let row = ceil(Double(count)/3.0)
            
            self.height = width*CGFloat(row)
            for i in 0...count-1{
                let row = CGFloat(i/3)
                let column = CGFloat(i%3)
                let x = column*width
                let y = row*width
                let gap = CGFloat(10)
                let im = images[i] as! UIImage
                let iv = UIImageView(image: im)
                iv.clipsToBounds = true
                iv.contentMode = UIViewContentMode.ScaleAspectFill
                iv.frame = CGRectMake(x+gap, y+gap, width-gap*2, width-gap*2)
                self.addSubview(iv)
                iv.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
                iv.addGestureRecognizer(tap)
                
            }
        }
    }
    
    func didTapImage(tap : UITapGestureRecognizer){
        let iv = tap.view as! UIImageView
        let ivLarge = UIImageView()
        ivLarge.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
        ivLarge.image = iv.image
        ivLarge.contentMode = UIViewContentMode.ScaleAspectFit
        ivLarge.clipsToBounds = true
        ivLarge.userInteractionEnabled = true
        UIApplication.sharedApplication().keyWindow?.addSubview(ivLarge)
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchImageLarge(_:)))
        ivLarge.addGestureRecognizer(tap)
        ivLarge.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(0.3, animations: {
            ivLarge.frame = UIScreen.mainScreen().bounds
        }) { (true) in
            
        }
    }
    
    func touchImageLarge(tap : UITapGestureRecognizer){
        let ivLarge = tap.view!
        UIView.animateWithDuration(0.3, animations: {
            ivLarge.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
            ivLarge.alpha = 0
        }) { (true) in
            ivLarge.removeFromSuperview()
        }
        
    }
    
}
