//
//  dateManager.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/07/04.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import Foundation



class dateManager:NSObject {
    
    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = NSDate()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    //月の初日を取得
    func firstDateOfMonth() -> NSDate {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day],
                                                                 fromDate: selectedDate)
        components.day = 1
        let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components)!
        return firstDateMonth
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDateOfMonth())
        
        for var i in 0...numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!
            // ④配列に追加
            currentMonthOfDates.append(date)
            
        }
        
        self.deleteNonCurrentMonthDates()
        
    }
    
    // ⑵表記の変更
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        var dateStr = formatter.stringFromDate(currentMonthOfDates[indexPath.row])
        let dateInt = Int(dateStr)
        if currentMonthOfDates.count > indexPath.row + 1 {
            let nextDate = formatter.stringFromDate(currentMonthOfDates[indexPath.row + 1])
            let nextDateInt = Int(nextDate)
            
            if (dateInt == nextDateInt) {
                dateStr = ""
            }
            
            if (dateInt == 1 && nextDateInt == 2) {
                dateStr = "1"
            }
        }
            
        return dateStr
    }
    
    //前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
    
    func deleteNonCurrentMonthDates() {
        var newDates = [NSDate]()
        for var date in currentMonthOfDates {
            if(self.isInCurrentMonth(date)) {
                newDates.append(date)
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let date  = "2015/01/01"
                let dummyDate = dateFormatter.dateFromString(date)
                newDates.append(dummyDate!)
            }
        }
        
        currentMonthOfDates = newDates
        
    }
    
    //今月でない日付はいらない
    func isInCurrentMonth(date: NSDate) -> Bool {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: selectedDate)
        let AnotherComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        return components.month == AnotherComp.month
    }
    
}

extension NSDate {
    func monthAgoDate() -> NSDate {
        let addValue = -1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func monthLaterDate() -> NSDate {
        let addValue: Int = 1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
}

