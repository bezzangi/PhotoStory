//
//  Util.swift
//  PhotoStory
//
//  Created by Bezzangi on 26/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit
import CoreData
class Util: NSObject {
    static func getUIImageArr(filePaths:NSString)->[UIImage] {
        let imgPathArr = filePaths.components(separatedBy: "|")
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        
        var rtv:[UIImage] = []
        
        for path in imgPathArr {
            if (path != "") {
            var img = UIImage(contentsOfFile:path)
            if (img != nil) {
                rtv.append(img!)
            }
            else {
                let url = NSURL.fileURL(withPath: path)
                let filename = url.lastPathComponent
                let path2 = directoryPath.appending(filename)
                img = UIImage(contentsOfFile:path2)
                if (img != nil) {
                    rtv.append(img!)
                }
            }
            }
        }
        return rtv
    }
    
    static func getFileNumber() -> Int {
        var settingArr: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return -1
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Setting",
                                                in: managedContext)!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Setting")
        
        do {
            try
                settingArr = managedContext.fetch(fetchRequest)
        } catch {
            
        }
        
        var setting:NSManagedObject
        
        var rtv = 0
        
        if (settingArr.count == 0) {
            setting = NSManagedObject(entity: entity, insertInto: managedContext)
        } else {
            setting = settingArr[0]
            rtv = setting.value(forKey: "fileNumber") as! Int
            rtv += 1
        }
        setting.setValue(rtv, forKey: "fileNumber")
        do {
            try
                managedContext.save()
        } catch {
            NSLog("Error")
        }
        
        return rtv
    }
    
    static func loadData(keyword:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        let sortDescriptor = NSSortDescriptor(key: "when", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@ OR memo CONTAINS %@", keyword, keyword )
        
        
        do {
            PhotoManager.sharedInstance.storyArr = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        PhotoManager.sharedInstance.monthStoryArray.removeAllObjects()
        for s in PhotoManager.sharedInstance.storyArr {
            //let monthStr = getMonthStr(date: s.value(forKey: "when") as! Date)
            PhotoManager.sharedInstance.addMonthArray(story: s)
            //NSLog("Month : " + monthStr)
        }
    }
    
    static func trim(str:NSString) -> String
    {
        return str.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    
    static func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        let sortDescriptor = NSSortDescriptor(key: "when", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            PhotoManager.sharedInstance.storyArr = try managedContext.fetch(fetchRequest)
            for s in PhotoManager.sharedInstance.storyArr {
                var toDelete = false
                if (s.value(forKey: "when") == nil) {
                    toDelete = true
                } else if (s.value(forKey: "photos") == nil) {
                    toDelete = true
                }
                //                else if (Util.getUIImageArr(filePaths:s.value(forKey: "photos") as! NSString).count == 0) {
                //                    toDelete = true
                //                }
                //                toDelete = true
                
                if (toDelete) {
                    managedContext.delete(s)
                    do {
                        try managedContext.save()
                    } catch {
                        
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        PhotoManager.sharedInstance.monthStoryArray.removeAllObjects()
        for s in PhotoManager.sharedInstance.storyArr {
            //let monthStr = getMonthStr(date: s.value(forKey: "when") as! Date)
            PhotoManager.sharedInstance.addMonthArray(story: s)
            //NSLog("Month : " + monthStr)
        }
        
//        let allKeys = PhotoManager.sharedInstance.getSortedKeys()
//        var arr:[NSManagedObject]
//        for key in allKeys {
//            arr = PhotoManager.sharedInstance.monthStoryArray.object(forKey: key) as! [NSManagedObject]
//            arr = arr.sorted(by: <#T##(NSManagedObject, NSManagedObject) -> Bool#>)
//        }
        
    }

    static func deletaAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
            for s in PhotoManager.sharedInstance.storyArr {
                managedContext.delete(s)
                do {
                     try managedContext.save()
                } catch {
                        
                }
            }
        
    }
    
    static func getDateStr(date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let rtv = formatter.string(from: date)
        return rtv
    }
    
    static func getMonthStr(date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let rtv = formatter.string(from: date)
        return rtv
    }
}
