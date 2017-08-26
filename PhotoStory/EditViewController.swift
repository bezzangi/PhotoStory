//
//  EditViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextViewDelegate {

    var scrollView = PhotoScrollView()
    var tvTitle = UITextField()
    var tvMemo = UITextView()
    var tvDate = UILabel()
    
    var lbPlaceHolder = UILabel()
    
    var mainScrollView = UIScrollView()
    
    var isEditMode = false
    
    var index:Int = 0
    var story:NSManagedObject? = nil
    var date:Date? = nil
    
    var _memo:String = ""
    var _title:String = ""
    
    
    func textViewDidChange(_ textView: UITextView) {
        // Do the logic you want to happen everytime the textView changes
        // if string is == "do it" etc....
        lbPlaceHolder.removeFromSuperview()
    }
    
    func initUI() {
        
        let h = view.frame.height
        let w = view.frame.width
        
        mainScrollView.frame = CGRect(x: 0, y: 70, width: w, height: h)
        mainScrollView.contentSize.width = w
        mainScrollView.contentSize.height = h * 2
        mainScrollView.isScrollEnabled = true
        view.addSubview(mainScrollView)
        
        let offset = 5
        var y = 0
        
        let size = PhotoManager.sharedInstance.scrollVSize
        
        scrollView.initUI()
        scrollView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width:(size?.width)!, height:CGFloat((size?.height)!))
        //scrollView.backgroundColor = UIColor.red
        scrollView.isScrollEnabled = true
        
        mainScrollView.addSubview(scrollView)
        
        var _x = 5
        
        if ((PhotoManager.sharedInstance.imageArr?.count)!>0)
        {
            for img in PhotoManager.sharedInstance.imageArr! {
                scrollView.addImage(image: img)
            }
            tvTitle.placeholder = "제목을 입력하세요"
            lbPlaceHolder.text = "메모를 입력하세요"
            
            tvMemo.addSubview(lbPlaceHolder)
            //tvMemo.placeholder = "메모를 입력하세요"
            
            date = generateRandomDate(daysBack: 180)!
        } else {
            //index = PhotoManager.sharedInstance.index
            story = PhotoManager.sharedInstance.selectedStory
            scrollView.addImageUsingPaths(paths: story?.value(forKey: "photos") as! NSString)
            tvTitle.text = story?.value(forKey: "title") as? String
            tvMemo.text = story?.value(forKey: "memo") as! String
            date = story?.value(forKey: "when") as? Date
            
            isEditMode = true
        }
        
        tvDate.text = Util.getDateStr(date:date!)
        
        
        _x = 5
        y += Int(scrollView.bounds.size.height) + offset
        tvTitle.frame = CGRect(x: _x, y: y, width:Int((size?.width)!), height: 40)
        tvTitle.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        tvTitle.borderStyle = UITextBorderStyle.line
        mainScrollView.addSubview(tvTitle)
        
        y += Int(tvTitle.bounds.size.height) + offset
        tvMemo.frame = CGRect(x: offset, y: y, width:Int((size?.width)!), height: 200)
        lbPlaceHolder.frame = CGRect(x: 5, y: 5, width: 100, height: 100)
        lbPlaceHolder.textColor = UIColor.lightGray
        mainScrollView.addSubview(tvMemo)
        tvMemo.delegate = self as UITextViewDelegate
        
        y += Int(tvMemo.bounds.size.height) + offset
        tvDate.frame = CGRect(x: offset, y: y, width:Int((size?.width)!), height: 40)
        mainScrollView.addSubview(tvDate)
        
     
        let customFont:UIFont = UIFont.init(name: (tvTitle.font?.fontName)!, size: 27.0)!
        tvTitle.font = customFont
        tvMemo.font = customFont
        lbPlaceHolder.font = customFont
        lbPlaceHolder.sizeToFit()
        
    }
    
    func enterPressed(){
        //do something with typed text if needed
        tvTitle.resignFirstResponder()
        tvMemo.resignFirstResponder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        initUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneClicked(_ sender: Any) {
        NSLog("Its done 1")
        
        _memo = Util.trim(str: tvMemo.text! as NSString)
        _title = Util.trim(str: tvTitle.text! as NSString)

        if (_memo == "" || _title == "") {
            let alert = UIAlertController(title: "", message: "제목과 메모을 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "Main", sender: sender)
        }
    }

    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "edit_done") {
            NSLog("save files...")
            save()
            Util.loadData()
        } else {
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        _memo = Util.trim(str: tvMemo.text! as NSString)
        _title = Util.trim(str: tvTitle.text! as NSString)
        if (identifier == "cancel")
        {
            return true
        }
        
        if (_memo == "" || _title == "") {
            let alert = UIAlertController(title: "", message: "제목과 메모을 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    func save() {
        if (isEditMode == false) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Story",
                                                    in: managedContext)!
            
            let story = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
            NSLog (tvTitle.text!)
            NSLog (tvMemo.text)
            
            
            var filePaths = ""
            for img in PhotoManager.sharedInstance.imageArr! {
                let index = PhotoManager.sharedInstance.imageArr?.index(of: img)
                let filePath = saveImageToDocumentDirectory(img, snum: 0, fnum: index!) + "|"
                filePaths.append(filePath)
            }
            filePaths = String(filePaths.characters.dropLast())
            
            PhotoManager.sharedInstance.imageArr?.removeAll()
            
            story.setValue(tvTitle.text, forKeyPath: "title")
            story.setValue(tvMemo.text, forKeyPath: "memo")
            story.setValue(date, forKey: "when")
            story.setValue(filePaths, forKey: "photos")
            
            do {
                try managedContext.save()
                PhotoManager.sharedInstance.storyArr.append(story)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            //let entity = NSEntityDescription.entity(forEntityName: "Story",in: managedContext)!
            NSLog (tvTitle.text!)
            NSLog (tvMemo.text)
            
            PhotoManager.sharedInstance.imageArr?.removeAll()
            
            story?.setValue(tvTitle.text, forKeyPath: "title")
            story?.setValue(tvMemo.text, forKeyPath: "memo")
            story?.setValue(date, forKey: "when")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage, snum:Int, fnum:Int) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filename = "s\(Util.getFileNumber()).jpg"
        let filepath = directoryPath.appending(filename)

        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            //return String.init("/Documents/\(filename)")
            return filename
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack)) + 1 // - daysBack
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        let day2 = (Int(day) - daysBack)
        
        offsetComponents.day = Int(day2)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        NSLog ("day : \(day2)")
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    
}
