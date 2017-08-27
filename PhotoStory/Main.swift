//
//  ViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//




import UIKit
import CoreData


class Main: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate  {

    @IBOutlet weak var toolBar: UIToolbar!
    var tfFind = UITextField()
    var tableView = UITableView()
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btnToHide1: UIBarButtonItem!
    @IBOutlet weak var btnToHide2: UIButton!
    
    
    @IBAction func deleteAll(_ sender: Any) {
        Util.deletaAll()
        tableView.reloadData()
        updateTitle()
    }
    
    func updateTitle() {
        navigationBar.topItem?.title = "스토리 (\(PhotoManager.sharedInstance.storyArr.count))"
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
        
        updateTitle()
        
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
        
        //let height = Int(h) - y - offset - Int(toolBar.bounds.height)
        let height = Int(h) - y - offset
        
        tableView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width: w - 2 * CGFloat(offset), height: CGFloat(height))
        tableView.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        view.addSubview(tfFind)
        tableView.reloadData()
        
        setScrollViewScreenSize()
        
        btnToHide1.title=""
        btnToHide2.removeFromSuperview()
       // PhotoManager.sharedInstance.storyArr.count
        toolBar.removeFromSuperview()
        
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
        let key = allKeys[section]
        let arr = PhotoManager.sharedInstance.monthStoryArray.object(forKey: key) as! NSArray
        let count = arr.count
        
//        let rtv = (allKeys[section] as String) + " (\(count))"
//        return allKeys[section] as String
        return (key as String) + " (\(count))"
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

