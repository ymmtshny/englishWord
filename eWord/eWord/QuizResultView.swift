//
//  QuizResultView.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/07/04.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit


protocol QuizResultViewDelegate {
    
    func tapQuizResultViewOKButton(sender: UIButton)
    
}

class QuizResultView :UIView {
    
    @IBOutlet weak var okButton : UIButton!
    @IBOutlet weak var correctNumberLable : UILabel!
    @IBOutlet weak var totalNumberLable :UILabel!
    @IBOutlet weak var mainView :UIView!
    @IBOutlet weak var resultImage :UIImageView!
    
    var delegate:QuizResultViewDelegate?
    
    class func instance() -> QuizResultView {
        return UINib(nibName: "QuizResultView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! QuizResultView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 8.0
        mainView.clipsToBounds = true
        okButton.addTarget(self, action: #selector(self.tapQuizResultViewOKButton(_:)), forControlEvents: UIControlEvents.TouchDown)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tapQuizResultViewOKButton(sender: UIButton) {
        self.delegate?.tapQuizResultViewOKButton(sender)
        
    }

    func setResultViewWith(correctNumber: Int, totalNumber: Int) {
        self.correctNumberLable.text = String(correctNumber)
        self.totalNumberLable.text = String(totalNumber)
        
        let percent = Double(correctNumber) / Double(totalNumber)
        
        if percent == 1 {
            
        } else if percent > 0.9 {
            
        } else if percent > 0.8 {
            
        } else if percent > 0.7 {
            
        } else if percent > 0.6 {
            
        } else if percent > 0.5 {
            
        } else {
            
        }
       
        
    }
    
}
