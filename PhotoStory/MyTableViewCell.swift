//
//  MyTableViewCell.swift
//  PhotoStory
//
//  Created by Younghwa Park on 25/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    var myLabel1: UILabel!
    var myLabel2: UILabel!
    var iv : UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 150
        let lineGap : CGFloat = 5
        let label2Y : CGFloat = gap + labelHeight + lineGap
        
        let ratio = 0.7
        let height = 80 - gap * 2;
        
        iv = UIImageView()
        iv.frame = CGRect(x: gap, y: gap, width: height * CGFloat(ratio), height: height)
        contentView.addSubview(iv)
        
        let x = gap * 2 + height * CGFloat(ratio)
        
        myLabel1 = UILabel()
        myLabel1.frame = CGRect(x: x, y: gap, width: labelWidth, height: labelHeight)
        myLabel1.textColor = UIColor.black
        contentView.addSubview(myLabel1)
        
        myLabel2 = UILabel()
        myLabel2.frame = CGRect(x: x, y: label2Y, width: labelWidth, height: labelHeight)
        myLabel2.textColor = UIColor.black
        contentView.addSubview(myLabel2)
       
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
