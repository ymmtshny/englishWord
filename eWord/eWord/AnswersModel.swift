////
////  AnswersModel.swift
////  eWord
////
////  Created by Shinya Yamamoto on 2016/06/24.
////  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
////

////isCompeleted
////isCompeletedByUser
////correctRate
////-----------------
//
//
////正解 isCorrect
////解答時間 answer_duration
////解答日時 answer_date
//
////--------------
///*
//
// 正解率　｜　80% 　| 60%  　|  40%  |   20%
//           ７日後 | 翌日出題|　すぐに出題。
//
// userが自ら覚えたとマークした場合、翌日以降出題 => ok なら覚えたとする。
//
// クイズ１回１０問 20%(3) 40%(3) 60%(3) 80%(1)
//
//
// */


import Foundation
import RealmSwift

class AnswersModel: Object {
    
    dynamic var isCorrect = ""
    dynamic var answer_duration = ""
    dynamic var answer_date = ""
    
    func setAnswer(answer:AnswersModel,
                      isCorrect: String,
                      answer_duration: String,
                      answer_date:String) {
        
        answer.isCorrect = isCorrect
        answer.answer_duration = answer_duration
        answer.answer_date = answer_date
        
    }
    
    func setAnswer(answer:AnswersModel, word:WordsModel) {
        
        try! realm!.write {
            word.answers.append(answer);
        }
        
    }
    

    //[2016/06/26,...]を返す
    func getAnswersDateArray() -> [String] {
        
        var dateArray = [String]()
        let realm = try! Realm()
        let results = realm.objects(AnswersModel)
        
        for result in results {
            let temp_answer_date = (result as AnswersModel).answer_date
            print("answer_date:\(temp_answer_date)")
            let date =  temp_answer_date.characters.split{$0 == "/"}.map(String.init)
            let year = date[0]
            let month = date[1]
            let day = date[2]
            let dateStr = "\(year)/\(month)/\(day)"
            dateArray.append(dateStr)
        }
        
        return dateArray
    }
    
    //とりあえずはじめに正解していたらtrue
    func isCorrectFromEngWord(eng_word:String) -> Bool {
        
        let word = WordsModel().getWord(eng_word)
        let usersDataArray = word!.answers
        let userDataWithCorrect = usersDataArray.first
        
        if userDataWithCorrect==nil {
            return false
        } else {
            return true
        }
        
    }
    
    func getLastAnswerFromEngWord(eng_word:String) -> String {
        
        let word = WordsModel().getWord(eng_word)
        let usersDataArray = word!.answers
        let userDataWithDate = usersDataArray.last
        
        if userDataWithDate==nil {
            return "未解答"
        } else {
            return (userDataWithDate?.answer_date)!
        }
        
    }
    
    func saveAnswer(answer:AnswersModel) {
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(answer)
            }
        } catch {
            print("saveUsersDB ERROR")
            
        }
        
    }
    
    
    func deleteLastAnswer() {
        
        do {
            
            let realm = try! Realm()
            let user = realm.objects(AnswersModel).last!
            try  realm.write {
                // 最後のデータ
                realm.delete(user)
                // 全てのデータ
                // realm.deleteAll()
                
            }
            
        } catch {
            print("deleteLastUsersData ERROR")
        }
    }
    
    func deleteAllAnswers() {
        
        do {
            
            let realm = try! Realm()
            try  realm.write {
                
                realm.deleteAll()
                
            }
            
        } catch {
            
            print("deleteAllUsersData ERROR")
            
        }
    }
    
}
