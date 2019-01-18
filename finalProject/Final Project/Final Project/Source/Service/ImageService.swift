//
//  ImageService.swift
//  Final Project
//
//  Created by 张水鉴 on 8/8/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import UIKit

///Mark: ImageService class
class ImageService{
    
    ///static constant cache for Image
    static let cache = NSCache<NSString, UIImage>()
    
    ///func to download Image
    static func downloadImage(withURL url: URL, completion: @escaping (_ image:UIImage)->()){
        let dataTask = URLSession.shared.dataTask(with: url){data, responseURL , error in
            var downloadedImage : UIImage?
            
            if let data = data{
                downloadedImage = UIImage(data: data)
            }
            if downloadedImage != nil{
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                completion(downloadedImage!)
            }
        }
        
        dataTask.resume()
    }
    
    static func getImage(withURL url: URL, completion: @escaping (_ image:UIImage)->()){
        if let image = cache.object(forKey: url.absoluteString as NSString){
            completion(image)
        }
        else{
            downloadImage(withURL: url, completion: completion)
        }
    }
}
