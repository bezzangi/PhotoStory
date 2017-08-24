//
//  EditViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    
    
    var scrollView = UIScrollView()
    var tvTitle = UITextField()
    var tvMemo = UITextView()
    var mainScrollView = UIScrollView()
    var datePicker = UIDatePicker()
    
    func initUI() {
        
        let h = view.frame.height
        let w = view.frame.width
        
        mainScrollView.frame = CGRect(x: 0, y: 70, width: w, height: h)
        mainScrollView.contentSize.width = w
        mainScrollView.contentSize.height = h * 2
        mainScrollView.isScrollEnabled = true
        view.addSubview(mainScrollView)
        
        let offset = 20
        var y = 0
        
        let size = PhotoManager.sharedInstance.scrollVSize
        
        scrollView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width:(size?.width)!, height:CGFloat((size?.height)!))
        scrollView.backgroundColor = UIColor.red
        scrollView.isScrollEnabled = true
        
        mainScrollView.addSubview(scrollView)
        
        var _x = 5
        var _y = 5
        
        for img in PhotoManager.sharedInstance.imageArr! {
            var iv = UIImageView()
            iv.image = img
            var aratio = (img.size.height) / (img.size.width)
            let ivHeight = scrollView.bounds.height-10
            let ivWidth = ivHeight / aratio
            iv.frame = CGRect(x: _x, y: _y, width: Int(ivWidth), height: Int(ivHeight))
            scrollView.addSubview(iv)
            _x += Int(ivWidth) + 5
            
            var size = scrollView.contentSize
            size.width += iv.bounds.width+5
            scrollView.contentSize = size
            
        }
        _x = 5
        y += Int(scrollView.bounds.size.height) + offset
        tvTitle.frame = CGRect(x: _x, y: y, width:Int((size?.width)!), height: 40)
        tvTitle.text = "타이틀은 블라블라"
//        tvTitle.layer.backgroundColor = UIColor.lightGray
        tvTitle.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        tvTitle.borderStyle = UITextBorderStyle.line
        mainScrollView.addSubview(tvTitle)
        
        y += Int(tvTitle.bounds.size.height) + offset
        tvMemo.frame = CGRect(x: offset, y: y, width:Int((size?.width)!), height: 200)
        tvMemo.text = "메모도 블라블라\n메모도 블라블라\n메모도 블라블라\n"
//        tvMemo.background = UIColor.lightGray
        mainScrollView.addSubview(tvMemo)
        
        y += Int(tvMemo.bounds.size.height) + offset
        datePicker.frame = CGRect(x: offset, y: y, width:Int((size?.width)!), height: 200)
        datePicker.datePickerMode = UIDatePickerMode.date
        mainScrollView.addSubview(datePicker)
        
        let customFont:UIFont = UIFont.init(name: (tvTitle.font?.fontName)!, size: 27.0)!
        tvTitle.font = customFont
        tvMemo.font = customFont
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
        performSegue(withIdentifier: "Main", sender: sender)
    }

    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "edit_done") {
            NSLog("save files...")
        } else {
            
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
        let filename = "s\(snum)f(fnum)".appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            return String.init("/Documents/\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
}
