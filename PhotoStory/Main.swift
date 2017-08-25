//
//  ViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//


// core data
// https://www.youtube.com/watch?v=My2TP_tnyk4
// http://seorenn.blogspot.kr/2014/03/iososx-coredata-1.html
// https://stackoverflow.com/questions/36397971/multiple-images-in-a-single-entry-core-data-in-swift
// https://petermcintyre.com/topics/uiimage-in-core-data/
//
// good tutorial, downloaded code works
// https://www.raywenderlich.com/145809/getting-started-core-data-tutorial
///


// custom table cell
// http://studyswift.blogspot.kr/2015/09/uitableviewcell-create-custom-prototype.html

// table view cell event
// https://www.weheartswift.com/how-to-make-a-simple-table-view-with-ios-8-and-swift/

// core data
// https://www.youtube.com/watch?v=da6W7wDh0Dw
// https://www.youtube.com/watch?v=FPQS0bfdhGc


import UIKit
import CoreData


class Main: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var _storyArr: [NSManagedObject] = []
    
    var tfFind = UITextField()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 80
        tableView.sectionHeaderHeight=30
        
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
         
        view.backgroundColor = UIColor.lightGray
        
        let h = view.frame.height
        let w = view.frame.width
        
        let offset = 20
        var y = 80
        
        tfFind.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width: w - 2 * CGFloat(offset), height: CGFloat(40))
        tfFind.text = "검색어를 입력하세요."
        tfFind.alpha = 1.0
        tfFind.isHidden = false
        tfFind.backgroundColor = UIColor.white
        tfFind.layer.cornerRadius = 5
        
        
        y += Int(tfFind.frame.height) + offset
        let height = Int(h) - y - offset
        tableView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width: w - 2 * CGFloat(offset), height: CGFloat(height))
        tableView.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        view.addSubview(tfFind)
//        view.willRemoveSubview(tableView)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        do {
            _storyArr = try managedContext.fetch(fetchRequest)
            for s in _storyArr {
                if (s.value(forKey: "when") == nil) {
                    managedContext.delete(s)
                    do {
                        try managedContext.save()
                    } catch {
                        
                    }
                }
            }
            PhotoManager.sharedInstance.storyArr = _storyArr
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.row == 0) {
//            return 100;
//        }
//        else {
//            return 260;
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        NSLog("Clicked...1")
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        NSLog("Clicked...2")
//    }
    
  
    func tableView(_ tableView: UITableView!, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        performSegue(withIdentifier: "Edit", sender: nil)
    }

//}
//
//
//// MARK: - UITableViewDataSource
//extension Main: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
//        NSLog ("Table count : \(PhotoManager.sharedInstance.storyArr.count)")
        return PhotoManager.sharedInstance.storyArr.count
    //    return 1;
    }

    func numberOfSections(in tableView: UITableView) -> Int {
    //    return PhotoManager.sharedInstance.storyArr.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section==1) {
            return "Section 1"
        }
        return "Section"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let story = PhotoManager.sharedInstance.storyArr[indexPath.row]
        let cell = MyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        
        let date = story.value(forKeyPath: "when") as? Date
        if (date != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sDate = dateFormatter.string(from:date!)
            cell.myLabel2.text = sDate
        }
        
        cell.myLabel1.text = story.value(forKeyPath: "title") as? String
        
        NSLog("\(indexPath.row) : \(story.value(forKeyPath: "when") as? Date)")
        
        
        return cell
    }

}

