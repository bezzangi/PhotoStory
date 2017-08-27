//
//  StoryViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit
import CoreData

class StoryViewController: UIViewController {

    var scrollView = PhotoScrollView()
    var lTitle = UILabel()
    var lMemo = UITextView()
    var lDate = UILabel()
    var lPhoto = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        var y = 70
        let offset = 5
        
        let story = PhotoManager.sharedInstance.selectedStory
        let width = Int(w)-offset * 2
        let size = PhotoManager.sharedInstance.scrollVSize
        
        
        lPhoto.frame = CGRect(x: offset, y: y, width:width, height: 50)
        let _c:Int = (story?.mutableSetValue(forKey: "photo").count)!
        lPhoto.text = "\(_c) 장의 사진"
        view.addSubview(lPhoto)
        
        
        y = y + Int(lPhoto.bounds.height) + offset
        scrollView.initUI()
        scrollView.frame = CGRect(x: offset, y: y, width:Int((size?.width)!), height: Int((size?.height)!))
        let photoArr:NSMutableSet = (story?.mutableSetValue(forKey: "photo"))!
        scrollView.addImageUsingMutableSet(set: photoArr)
        
        view.addSubview(scrollView)
        
        y = y + Int(scrollView.bounds.height) + offset
        lTitle.frame = CGRect(x: offset, y: y, width:width, height: 50)
        lTitle.text = story?.value(forKey: "title") as? String
        view.addSubview(lTitle)
        
        y = y + Int(lTitle.bounds.height) + offset
        lMemo.frame = CGRect(x: offset, y: y, width:width, height: 150)
        lMemo.text = story?.value(forKey: "memo") as! String
        lMemo.isEditable = false
        view.addSubview(lMemo)
        
        y = y + Int(lMemo.bounds.height) + offset
        lDate.frame = CGRect(x: offset, y: y, width:width, height: 50)
        lDate.text = Util.getDateStr(date: story?.value(forKey: "when") as! Date)
        view.addSubview(lDate)
        
        
        let customFont1:UIFont = UIFont.init(name: (lTitle.font?.fontName)!, size: 27.0)!
        let customFont2:UIFont = UIFont.init(name: (lTitle.font?.fontName)!, size: 20.0)!
        
        lTitle.font = customFont1
        lMemo.font = customFont2
        
        view.backgroundColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }


//    @IBAction func delBtn(_ sender: Any) {
//        Util.deleteStory(story:PhotoManager.sharedInstance.selectedStory!)
//        performSegue(withIdentifier: "delete", sender: sender)
//    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "delete") {
            Util.deleteStory(story:PhotoManager.sharedInstance.selectedStory!)
            PhotoManager.sharedInstance.selectedStory = nil
            return true
        } else if (identifier == "home") {
            PhotoManager.sharedInstance.selectedStory = nil
            return true
        }
        return true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
