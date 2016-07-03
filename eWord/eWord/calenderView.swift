//
//  calenderView.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/05/29.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

//MyCollectionViewCell => xib 
//これじゃなくて
//self.myCollectionView.registerClass(calenderCell.self, forCellWithReuseIdentifier: "calenderCell")
//これ！！！
//self.myCollectionView.registerNib(UINib(nibName: "calenderCell", bundle: nil), forCellWithReuseIdentifier: "calenderCell")
import UIKit

class calenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var lastMonthButton: UIButton!
    
    let date_manager = dateManager()
    var answerDateArray = [String]()
    var selectedDate = NSDate()
    var currentMonth = 0
    
    class func instance() -> calenderView {
        return UINib(nibName: "calenderView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! calenderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        
        nextMonthButton.addTarget(self, action: #selector(self.tapNextMonthButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        lastMonthButton.addTarget(self, action: #selector(self.tapLastMonthButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        thisMonthLabel.text = changeHeaderTitle(selectedDate)
        self.setCurrentMonth()
        
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.backgroundColor = UIColor.whiteColor()
        self.myCollectionView.registerNib(UINib(nibName: "calenderCell", bundle: nil), forCellWithReuseIdentifier: "calenderCell")
        self.myCollectionView.reloadData()
        
        
    }
    
    @IBAction func tapLastMonthButton(sender: UIButton) {
        selectedDate = date_manager.prevMonth(selectedDate)
        myCollectionView.reloadData()
        thisMonthLabel.text = changeHeaderTitle(selectedDate)
        self.setCurrentMonth()
    }

    @IBAction func tapNextMonthButton(sender: UIButton) {
        selectedDate = date_manager.nextMonth(selectedDate)
        myCollectionView.reloadData()
        thisMonthLabel.text = changeHeaderTitle(selectedDate)
        self.setCurrentMonth()
    }
    
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年　M月"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    func setCurrentMonth() {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年　M月"
        let date = formatter.dateFromString(self.thisMonthLabel.text!)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date!)
        self.currentMonth = components.month
    }
    
    
    //MARK:Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return date_manager.daysAcquisition()
        
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:
        NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calenderCell", forIndexPath: indexPath) as! calenderCell
        
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            
            cell.dateLabel.textColor = UIColor.lightRed()
            
        } else if (indexPath.row % 7 == 6) {
            
            cell.dateLabel.textColor = UIColor.lightBlue()
            
        } else {
            
            cell.dateLabel.textColor = UIColor.grayColor()
            
        }
        
        //テキスト配置
        let dateStr = date_manager.conversionDateFormat(indexPath)
        cell.dateLabel.text = dateStr
        
        if dateStr != "" {
            self.setColorLevelCell(cell, month:self.currentMonth, date:Int(dateStr)!)
        }
        
        return cell
        
    }
    
    // セルのサイズを返却する
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(myCollectionView.frame.size.width/7, myCollectionView.frame.size.width/7)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("タップされたよー");
    }
    
    
    //FIXME:
    func setColorLevelCell(cell: calenderCell, month:Int, date:Int) {
        
        var numberOfMatch = 0;
        
        for dateStr in answerDateArray {
            
            let tmp_DateStrArray = dateStr.characters.split{$0 == "/"}.map(String.init)
            let month_str        = tmp_DateStrArray[1]
            let date_str         = tmp_DateStrArray[2]
            let month_int        = Int(month_str)
            let date_int         = Int(date_str)
            
            if(month_int == month && date_int == date) {
                numberOfMatch += 1
            }
        }
        
        var level = colorLevel.level0
        
             if(numberOfMatch < 10) { level = .level0 }
        else if(numberOfMatch < 20) { level = .level1 }
        else if(numberOfMatch < 30) { level = .level2 }
        else                        { level = .level3 }
        
        cell.paintCell(colorLevel: level);
        
    }
    
    
}