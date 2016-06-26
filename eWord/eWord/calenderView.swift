//
//  calenderView.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/05/29.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

//MyCollectionViewCell => xib 

import UIKit

class calenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var dateArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.registerClass(calenderCell.self, forCellWithReuseIdentifier: "calenderCell")
        self.myCollectionView.backgroundColor = UIColor.whiteColor()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    func getDaysInMonth(month:Int) -> Int {
        
        let dateComponents = NSDateComponents()
        dateComponents.month = 7
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(dateComponents)!
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        let numDays = range.length
        return numDays
    }
    
    
    //MARK:Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            //return dateManager.daysAcquisition() //ここは月によって異なる
            return self.getDaysInMonth(5)
        }
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:
        NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calenderCell", forIndexPath: indexPath) as! calenderCell

// FIXME:nilで落ちる！fuck!!!
//        if indexPath.section == 0 {
//            
//            cell.dateLabel!.text = weekArray[indexPath.row]
//            
//        } else {
//            
//            cell.dateLabel!.text = String(indexPath.row + 1)
//            
//        }
        
        self.setColorLevelCell(cell, month: 6, date: indexPath.row + 1)
        
        return cell
    }
    
    // セルのサイズを返却する
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(myCollectionView.frame.size.width/7, myCollectionView.frame.size.width/7)
    }
    
    func setColorLevelCell(cell: calenderCell, month:Int, date:Int) {
        
        var numberOfMatch = 0;
        
        for dateStr in dateArray {
            
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