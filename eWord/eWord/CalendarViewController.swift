//
//  CalendarViewController.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var calender: calenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCanlenderView()
        self.colorCalenderCell()
    }
    
    func colorCalenderCell() {
        calender.answerDateArray = AnswersModel().getAnswersDateArray()
        calender.myCollectionView.reloadData()
    }
    
    //MARK:canlenderView
    func addCanlenderView() {
        
        let bundle = NSBundle(forClass: calenderView.self)
        calender = bundle.loadNibNamed("calenderView", owner: nil, options: nil)[0] as! calenderView
        self.view.addSubview(calender)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
