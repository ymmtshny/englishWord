//
//  LevelSelectView.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/05/25.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

class LevelSelectView :UIView {
    
    
    @IBOutlet weak var mySrollView: UIScrollView!
    var levelButtonsArray:[UIButton]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.levelButtonsArray = []
        for index in 0...5 {
            let button = UIButton();
            button.setTitle("レベル\(index)", forState: .Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.tag = index
            let x = CGFloat(index * 200)
            let y = CGFloat(self.frame.size.height * 0.5)
            button.frame = CGRectMake(x, y, 200, 100)
            self.mySrollView.addSubview(button)
            self.mySrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame),self.frame.size.height);
            
            levelButtonsArray.append(button);
        }

        
    }
        
    
    override init(frame: CGRect) {
        self.levelButtonsArray = []
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.levelButtonsArray = []
        super.init(coder: aDecoder)
    }
    
}
