//
//  collectionViewCell.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/05/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

enum colorLevel {
    case level0
    case level1
    case level2
    case level3
}

class calenderCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel! = UILabel()
    var level: colorLevel = colorLevel.level1
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        let bundle = NSBundle(forClass: calenderCell.self)
        let nib = UINib(nibName: "calenderCell", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        self.addSubview(view)
    }
    
    //MARK:cellの色
    func paintCell(colorLevel level:colorLevel) {
        
        switch level {
        case .level0:
            self.backgroundColor = UIColor.rgb(r: 255, g: 255, b: 255, alpha: 1)
        case .level1:
            self.backgroundColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1)
        case .level2:
            self.backgroundColor = UIColor.rgb(r: 235, g: 235, b: 235, alpha: 1)
        case .level3:
            self.backgroundColor = UIColor.rgb(r: 225, g: 225, b: 225, alpha: 1)
        }
    }
}

