//
//  PhotoScrollView.swift
//  PhotoStory
//
//  Created by Bezzangi on 26/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit

class PhotoScrollView: UIScrollView {
    var imageArr : [UIImage]? = []
    var imageViewArr : [UIImageView]? = []
    
    static var width:CGFloat = 0
    static var height:CGFloat = 0

    let offset = 5
    var ivx = 0
    
    func initUI() {
        self.isScrollEnabled = true
 //       self.backgroundColor = UIColor.blue
        self.frame = CGRect(x: 5, y: 80, width: 300, height: 100)
    }
    
    
    func bigImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.removeFromSuperview()
    }

    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        var bigImageView = UIImageView()
        bigImageView.frame = (self.superview?.frame)!
        bigImageView.image = tappedImage.image
        superview?.addSubview(bigImageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bigImageTapped(tapGestureRecognizer:)))
        bigImageView.isUserInteractionEnabled = true
        bigImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    func addImage(image:UIImage) {
        let aratio = (image.size.height) / (image.size.width)
        let iv = UIImageView()
        let ivHeight = self.bounds.height
        let ivWidth = ivHeight / aratio
        iv.frame = CGRect(x: ivx, y: 0, width: Int(ivWidth), height: Int(ivHeight))
        self.addSubview(iv)
        iv.image = image
        ivx += Int(ivWidth) + 5
        var size = self.contentSize
        size.width += iv.bounds.width+5
        self.contentSize = size
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    func addImageUsingPaths(paths:NSString) {
        let images = Util.getUIImageArr(filePaths: paths)
        for img in images {
            self.addImage(image: img)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
