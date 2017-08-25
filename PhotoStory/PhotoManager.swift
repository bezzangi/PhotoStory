//
//  PhotoManager.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit
import CoreData

final class PhotoManager {
        //MARK: Shared Instance
        
        static let sharedInstance : PhotoManager = {
            let instance = PhotoManager()
            return instance
        }()
    
    var imageArr : [UIImage]? = []
    var scrollVSize:CGSize? = nil
    var storyArr: [NSManagedObject] = []
    
    func addImage(img:UIImage) {
        imageArr?.append(img)
    }
    func addSVSize(s:CGSize) {
        scrollVSize = s
    }
    
    
}
