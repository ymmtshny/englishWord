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
    
    
    @IBOutlet weak var dateLabel: UILabel!
    var level: colorLevel = colorLevel.level1
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    //MARK:cellの色
    func paintCell(colorLevel level:colorLevel) {
        
        switch level {
        case .level0:
            self.backgroundColor = UIColor.whiteColor()
        case .level1:
            self.backgroundColor = UIColor.whiteColor()
        case .level2:
            self.backgroundColor = UIColor.lightGrayColor()
        case .level3:
            self.backgroundColor = UIColor.grayColor()
        }
    }
}

