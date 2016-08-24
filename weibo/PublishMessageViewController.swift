//
//  PublishMessageViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD

let uploadWithPicURL = "https://upload.api.weibo.com/2/statuses/upload.json"
let uploadWithoutPicURL = "https://api.weibo.com/2/statuses/update.json"

class PublishMessageViewController: UIViewController , UITextViewDelegate{
    
    
    var images : [UIImage]?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageContainerView: ImageContainerView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        if images != nil{
            imageContainerView.updateImageContainer(images!)
            imageHeight.constant = imageContainerView.height
        }
        else{
            imageContainerView.hidden = true
        }
    }
    
    @IBAction func didTapCancle(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    @IBAction func didTapSend(sender: UIBarButtonItem) {
        
        if textView.text.characters.count <= 0 || textView.text.characters.count >= 140{
            CustomToast.showHudToastWithString("words' length must be 0-140")
            return
        }
        
        let status = textView.text
        var params : [String : AnyObject]?
        var urlString = ""
        if images != nil{
            urlString = uploadWithPicURL
           
            
            
            
            /*
            //let data = UIImageJPEGRepresentation(images![0], 0.8)
//            let data = UIImagePNGRepresentation(images![0])
            
            //图片上传要求使用multipart/form-data格式
            
            let URL = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: URL!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
            let boundary = "wtdgSHJDUweriuoHYrSdf"
            request.allHTTPHeaderFields = ["content-Type" : "multipart/form-data;boundary=\(boundary)"]
            request.HTTPMethod = "POST"
            let data = NSMutableData()
            let access = "---\(boundary)\r\nContent-Disposition: form-data; name=access_token\r\n\r\n\(ShareManager.shareInstance.userAccount.accessToken)\r\n";
            data.appendData(access.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let status = "---\(boundary)\r\nContent-Disposition: form-data; name=status\r\n\r\n\(status)\r\n";
            data.appendData(status.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let pic = "---\(boundary)\r\nContent-Disposition: form-data; name=pic; filename=1.jpg; Content-type=image/jpg\r\n\r\n";
            data.appendData(pic.dataUsingEncoding(NSUTF8StringEncoding)!)
            let imData = UIImageJPEGRepresentation(images![0], 0.8)
            data.appendData(imData!)
            data.appendData("\r\n--\(boundary)---\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            request.HTTPBody = data
            request.setValue("\(data.length)", forHTTPHeaderField: "Content-Length")
            
            
            let session = NSURLSession.sharedSession()
            SVProgressHUD.show()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                SVProgressHUD.dismiss()
                if response != nil{
                    print("response---\(response)")
                }
                if data != nil{
                    print("data---\(data)")
                }
                if error != nil{
                    print("error---\(error)")
                }

            })
            task.resume()*/
            
            
            
            
            /*
            SVProgressHUD.show()
            
            Alamofire.request(request).response(completionHandler: { (requst, response, data, error) in
                
                SVProgressHUD.dismiss()
                if response != nil{
                    print("response---\(response)")
                }
                if error != nil{
                    print("error---\(error)")
                }
                
            })*/
            
            
            
            params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "status" : status]
            
            let imData = UIImageJPEGRepresentation(images![0], 1.0)
            
            SVProgressHUD.show()
            Alamofire.upload(.POST, urlString, multipartFormData: { data in
                
                data.appendBodyPart(data: ShareManager.shareInstance.userAccount.accessToken!.dataUsingEncoding(NSUTF8StringEncoding)!, name: "access_token")
                data.appendBodyPart(data: status.dataUsingEncoding(NSUTF8StringEncoding)!, name: "status")
//                data.appendBodyPart(data: imData!, name: "pic", mimeType: "image/jpeg")
                data.appendBodyPart(data: imData!, name: "pic", fileName: "file", mimeType: "image/jpeg")
                }, encodingCompletion: { encodingResult in
                    
                    
                    switch encodingResult{
                    case .Success(let upload, _,_):
                        
                        upload.responseJSON(completionHandler: { (response : Response<AnyObject, NSError>) in
                            
                            SVProgressHUD.dismiss()
                            
                            let error = response.result.error
                            let json = response.result.value
                            if json != nil{
                                print("response---\(json)")
                                CustomToast.showHudToastWithString("success!")
                                NSNotificationCenter.defaultCenter().postNotificationName(kDataChangeNotification, object: nil)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            if error != nil{
                                print("error---\(error)")
                            }
                        })
                        break
                    case .Failure(let error):
                        
                        print("error---\(error)")
                        break
                    }
            })
            
            
        }
        else{
            urlString = uploadWithoutPicURL
            params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "status" : status]
            
            SVProgressHUD.show()
            Alamofire.request(.POST, urlString, parameters: params).responseJSON { (response : Response<AnyObject, NSError>) in
                
                SVProgressHUD.dismiss()
                let error = response.result.error
                let json = response.result.value
                if error != nil{
                    print("error---\(error)")
                }
                if json != nil{
                    print("json---\(json)")
                    CustomToast.showHudToastWithString("success!")
                }
                self.dismissViewControllerAnimated(true) {
                    NSNotificationCenter.defaultCenter().postNotificationName(kDataChangeNotification, object: nil)
                }
            }

        }
        
        
        
    }
    
    
    //MARK: textview delegate
    
    func textViewDidChange(textView: UITextView) {
        
        placeholderLabel.hidden = textView.text.characters.count > 0
    }
}
