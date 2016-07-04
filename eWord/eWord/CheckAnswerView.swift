//
//  quizResultView.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/07/04.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

protocol CheckAnswerViewDelegate {
    
    func tapOKButton(sender: UIButton)
    
}

class CheckAnswerView :UIView {
    
    @IBOutlet weak var okButton : UIButton!
    @IBOutlet weak var engLabel : UILabel!
    @IBOutlet weak var jpLabel :UILabel!
    @IBOutlet weak var mainView :UIView!
    var delegate:CheckAnswerViewDelegate?
    
    class func instance() -> CheckAnswerView {
        return UINib(nibName: "CheckAnswerView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! CheckAnswerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 8.0
        mainView.clipsToBounds = true
        okButton.addTarget(self, action: #selector(self.tapOKButton(_:)), forControlEvents: UIControlEvents.TouchDown)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tapOKButton(sender: UIButton) {
        self.delegate?.tapOKButton(sender)
        
    }
    
}
