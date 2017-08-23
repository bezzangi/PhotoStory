//
//  ViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit

class Main: UIViewController {

    var tfFind = UITextField()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

