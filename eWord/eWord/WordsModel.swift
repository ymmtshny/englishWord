//
//  WordsModel.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/24.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//


import RealmSwift

class WordsModel: Object {

    dynamic var level = ""
    dynamic var eng_word = ""
    dynamic var jp_word = ""
    dynamic var eng_sentence = ""
    dynamic var jp_sentence = ""
    let answers = List<AnswersModel>()

    //MARK:setter
    func setWord(word:WordsModel,
                level:String,
             eng_word:String,
              jp_word:String,
         eng_sentence:String,
          jp_sentence:String,
        answersArray:[AnswersModel]) {

        word.level = level
        word.eng_word = eng_word
        word.jp_word = jp_word
        word.eng_sentence = eng_sentence
        word.jp_sentence = jp_sentence

        for answer in answersArray {
            word.answers.append(answer)
        }
        
    }

    //MARK:getter
    func getWord() -> [[String:String]] {

        var dicArray = [[String:String]]()

        let realm = try! Realm()
        let results = realm.objects(WordsModel)

        for result in results {
            var dictinary = [String:String]()
            dictinary["eng_word"] = (result as WordsModel).eng_word;
            dictinary["jp_word"] = (result as WordsModel).jp_word;
            dicArray.append(dictinary);
        }

        //print(dicArray)
        return dicArray;

    }
    
    func getWord(eng_word:String) -> WordsModel? {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "eng_word = %@", "\(eng_word)")
        let word = realm.objects(WordsModel.self).filter(predicate).first
        return word

    }

    //MARK:save
    func saveWord(word:WordsModel) {

        do {
            let realm = try Realm()

            try realm.write {
                realm.add(word)
            }
        } catch {
            print("saveWordsDB ERROR")

        }

    }

    //MARK:update
    func updateWord(word:WordsModel,
                       level:String,
                       eng_word:String,
                       jp_word:String,
                       eng_sentence:String,
                       jp_sentence:String,
                       AnswersArray:[AnswersModel]) {


        do {
            let realm = try! Realm()

            let word = realm.objects(WordsModel.self).filter("eng_word = \(eng_word)").first!
            try  realm.write {
                word.level = level
                word.eng_word = eng_word
                word.jp_word = jp_word
                word.eng_sentence = eng_sentence
                word.jp_sentence = jp_sentence

                for answer in AnswersArray {
                    word.answers.append(answer)
                }
            }

        } catch {

            print("updateWordsDB ERROR")

        }
    }


    // データの削除
    func deleteAllWords() {

        do {
            let realm = try! Realm()

            try  realm.write {

                 //全てのデータ
                 realm.deleteAll()

            }
        } catch {

        }
    }





    func deleteLastWord() {

        do {

            let realm = try! Realm()
            let word = realm.objects(WordsModel).last!
            try  realm.write {
                // 最後のデータ
                realm.delete(word)

            }

        } catch {

            print("deleteLastWordsData ERROR")

        }

    }

    //MARK:CSV
    func loadCSVData()-> [[String:String]]{

        var wordList = [[String:String]]()
        if let csvFilePath = NSBundle.mainBundle().pathForResource("words", ofType: "csv") {

            do {
                if let csvStringData: String = try String(contentsOfFile: csvFilePath) {

                    let array = csvStringData.characters.split{$0 == ","}.map(String.init)
                    var enArray = [String]()
                    var jpArray = [String]()
                    var word: Dictionary = [String:String]()
                    var wordsdb = WordsModel()
                    // wordsdb.deleteAll()


                    for index in 0...array.count-1 {

                        let data = array[index]

                        if(index % 2 == 0) {
                            wordsdb = WordsModel()
                            enArray.append(data)
                            wordsdb.eng_word = data

                        } else {

                            jpArray.append(data)
                            wordsdb.jp_word = data
                            wordsdb.saveWord(wordsdb)
                        }



                    }

                    for index in 0...enArray.count-1 {

                        word["eng_word"] = enArray[index]
                        word["jp_word"] = jpArray[index]
                        wordList.append(word)
                    }


                    //csv一回読み込んでrealmに保存したよと。
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "isLoadedWordsCSV")
                }

            } catch let error {

                print(error)
            }

        }

        return wordList;
    }
    
    private func getRandomNumberWithMax(max: Int) -> Int {
        let count = UInt32(max)
        let random = arc4random_uniform(count)
        let randomInt = Int(random)
        return randomInt
    }
    
    private func getEnglishFromDictionary(dic :Dictionary<String, String>) -> String! {
        
        return dic["eng_word"]
    }
    
    private func getJapaneseFromDictionary(dic :Dictionary<String, String>) -> String! {
        
        return dic["jp_word"]
    }
    
    private func shuffleArray(array:[String]) -> [String] {
        var array = array
        let idx = self.getRandomNumberWithMax(array.count)
        let elem = array[idx]
        let answer = array[1] //答え
        if idx != 0 {//array[0]は英語
            
            array[idx] = answer
            array[1] = elem
            //self.answerIdx = idx
            
        } else {
            
            //self.answerIdx = 1
        }
        return array
        
    }
    
    func getOneQuiz() -> [String:String]{
        
        var wordList = [[String:String]]()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isLoadedCSVData = defaults.boolForKey("isLoadedWordsCSV");
        if(!isLoadedCSVData){
            wordList = WordsModel().loadCSVData()
        } else {
            wordList = WordsModel().getWord()
        }
        
        let idxA = self.getRandomNumberWithMax(wordList.count)
        let idxB = self.getRandomNumberWithMax(wordList.count)
        let idxC = self.getRandomNumberWithMax(wordList.count)
        let idxD = self.getRandomNumberWithMax(wordList.count)
        
        let dicA = wordList[idxA]
        let dicB = wordList[idxB]
        let dicC = wordList[idxC]
        let dicD = wordList[idxD]
        
        let question = self.getEnglishFromDictionary(dicA)
        let optionA = self.getJapaneseFromDictionary(dicA)
        let optionB = self.getJapaneseFromDictionary(dicB)
        let optionC = self.getJapaneseFromDictionary(dicC)
        let optionD = self.getJapaneseFromDictionary(dicD)
        let answer  = self.getJapaneseFromDictionary(dicA)
        
        let quizDic: Dictionary = ["question":question!,
                                       "optionA":optionA!,
                                       "optionB":optionB!,
                                       "optionC":optionC!,
                                       "optionD":optionD!,
                                        "answer":answer!]
        
        return quizDic
        
    }

}



