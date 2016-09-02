//
//  ImageCheckerController.swift
//  weibo
//
//  Created by 武淅 段 on 16/9/2.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCheckerController: UICollectionViewController {

    
    var images : NSArray?
    var index : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.pagingEnabled = true
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.scrollToItemAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)

        //self.collectionView?.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
           }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images == nil ? 0 : images!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)as! ImageCell
//        let imgUrl = images![indexPath.row].valueForKey("thumbnail_pic")?.stringValue
        let imgUrl = images![indexPath.row].objectForKey("thumbnail_pic") as! String
        cell.imageView.sd_setImageWithURL(NSURL(string: imgUrl))
        //cell.imageView.image = UIImage(named: "add")
        return cell
    }

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
