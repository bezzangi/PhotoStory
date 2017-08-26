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

//웹서버 엑셀 문서 읽기 라이브러리 수정
//
//증상 : 워닝 메시지 발생
//원인 : php 문법 변화
//조치 :  /data/www/html/lib/Excel/reader.php 파일 수정
//관련 문서 :
//https://stackoverflow.com/questions/17187970/deprecated-assigning-the-return-value-of-new-by-reference-is-deprecated-in-phpe





import UIKit
import CoreData


class Main: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate  {

    @IBOutlet weak var toolBar: UIToolbar!
    var tfFind = UITextField()
    var tableView = UITableView()
    
    
    @IBOutlet weak var btnToHide1: UIBarButtonItem!
    @IBOutlet weak var btnToHide2: UIButton!
    
    
    @IBAction func deleteAll(_ sender: Any) {
        Util.deletaAll()
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        PhotoManager.sharedInstance.keyword = textField.text!
        if (PhotoManager.sharedInstance.keyword == "") {
            Util.loadData()
            tfFind.placeholder = "검색어를 입력하세요."
        } else {
            Util.loadData(keyword: PhotoManager.sharedInstance.keyword)
        }
        tableView.reloadData()
        return true
    }


    
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
        //tfFind.text = "검색어를 입력하세요."
        if (PhotoManager.sharedInstance.keyword  == "") {
            tfFind.placeholder = "검색어를 입력하세요."
        } else {
            tfFind.text = PhotoManager.sharedInstance.keyword
        }
        
        tfFind.alpha = 1.0
        tfFind.isHidden = false
        tfFind.backgroundColor = UIColor.white
        tfFind.layer.cornerRadius = 5
        tfFind.delegate = self
        
        
        y += Int(tfFind.frame.height) + offset
        let height = Int(h) - y - offset - Int(toolBar.bounds.height)
        
        tableView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width: w - 2 * CGFloat(offset), height: CGFloat(height))
        tableView.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        view.addSubview(tfFind)
        tableView.reloadData()
        
        setScrollViewScreenSize()
        
        btnToHide1.title=""
//        btnToHide2.removeFromSuperview()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Util.loadData()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    
    func setScrollViewScreenSize() {
        let h = view.frame.height
        let w = view.frame.width
        
        let offset = 5
        var y = 70
        
        let width = w - 2 * CGFloat(offset)
        
        y = y + Int(width) + offset
        
        let height = Int(h) - y - offset - Int(toolBar.bounds.height)
        
        let size = CGSize(width: width, height: CGFloat(height))
        
        PhotoManager.sharedInstance.scrollVSize = size
    }
    
    

  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allKeys = PhotoManager.sharedInstance.getSortedKeys()
        let key = allKeys[indexPath.section]
        
        let arr = PhotoManager.sharedInstance.monthStoryArray.object(forKey: key) as! NSArray
        let story = arr[indexPath.row] as! NSManagedObject
        
        PhotoManager.sharedInstance.selectedStory = story

        performSegue(withIdentifier: "Edit", sender: nil)
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let allKeys = PhotoManager.sharedInstance.getSortedKeys()
        let key = allKeys[section]
        let arr = PhotoManager.sharedInstance.monthStoryArray.object(forKey: key) as! NSArray
        return arr.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return PhotoManager.sharedInstance.monthStoryArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allKeys = PhotoManager.sharedInstance.getSortedKeys()
        
        return allKeys[section] as String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allKeys = PhotoManager.sharedInstance.getSortedKeys()
        let key = allKeys[indexPath.section]
        let arr = PhotoManager.sharedInstance.monthStoryArray.object(forKey: key) as! NSArray
        let story = arr[indexPath.row] as! NSManagedObject
        
        let cell = MyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        
        let date = story.value(forKeyPath: "when") as? Date
        if (date != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sDate = dateFormatter.string(from:date!)
            cell.myLabel2.text = sDate
        }
        
        cell.myLabel1.text = story.value(forKeyPath: "title") as? String
        
        
        let photoArr:NSMutableSet = (story.mutableSetValue(forKey: "photo"))
        let filePath = (photoArr.allObjects[0] as! NSManagedObject).value(forKey: "path") as! String
        let image = Util.getUIImageArr(filePaths: filePath as NSString)[0]

        cell.iv.image = image
        
        return cell
    }
}

