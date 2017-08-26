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
    //var index:Int = 0
    var selectedStory:NSManagedObject? = nil
    var keyword:String = ""
    
    func addImage(img:UIImage) {
        imageArr?.append(img)
    }
//    func addSVSize(s:CGSize) {
//        scrollVSize = s
//    }
    var monthStoryArray : NSMutableDictionary!
    
    func initData() {
        monthStoryArray = NSMutableDictionary()
    }
    
    
    
    //var monthStoryArray:NSDictionary = NSDictionary()
    
    func addMonthArray(story:NSManagedObject) {
        _ = monthStoryArray
        var storyArray:[NSManagedObject]? = []
        let dateStr = Util.getMonthStr(date: story.value(forKey: "when") as! Date)
        
        let obj = monthStoryArray.object(forKey: dateStr)
        if (obj != nil) {
            storyArray = obj as? [NSManagedObject]
        } else {
            storyArray = NSArray() as? [NSManagedObject]
            //monthStoryArray.setValue(storyArray, forKey: dateStr)
        }
        storyArray?.append(story)
        monthStoryArray.setValue(storyArray, forKey: dateStr)

//        NSLog("\(monthStoryArray)")
//        NSLog("\(storyArray)")

    }
    
    func getSortedKeys() -> [NSString] {
        let allKeys = PhotoManager.sharedInstance.monthStoryArray.allKeys as! [String]
        let sortedKeys = allKeys.sorted(){$0 > $1}
        return sortedKeys as [NSString]
    }
}
