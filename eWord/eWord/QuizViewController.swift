//
//  QuizViewController.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController, QuizViewDelegate {
    
    @IBOutlet weak var quizView: QuizView!
    var levelSelectView:LevelSelectView!
    
    var correctAudioPlayer = AVAudioPlayer()
    var wrongAudioPlayer = AVAudioPlayer()
    
    let correctSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("correct", ofType: "mp3")!)
    let wrongSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrong", ofType: "mp3")!)
    
    var quizDic = [String:String]()
    
    var solveTimes = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addQuizView()
        self.setQuestion()
        
    }
    
    //MARK:QuizView
    func addQuizView() {
        
        let bundle = NSBundle(forClass: QuizView.self)
        self.quizView = bundle.loadNibNamed("QuizView", owner: nil, options: nil)[0] as! QuizView
        self.quizView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.quizView.delegate  = self
        self.view.addSubview(self.quizView)
        
        
    }
    
    @IBAction func tapAnswerButton(sender: UIButton) {
        
        sender.enabled = false
        solveTimes += 1;
        
        let userAnswer = sender.titleLabel?.text
        let quizAnswer = quizDic["answer"]!
        let quizEnglish = quizDic["question"]!
        
        self.checkAnswer(userAnswer!,quizAnswer: quizAnswer, quizQuestion: quizEnglish)
        
        UIView.animateWithDuration(1, animations: {
            
            self.quizView.check_image.alpha = 0
            
            }, completion: {(value: Bool) in
                
                if(self.solveTimes < 10) {
                    
                    self.setQuestion()
                    sender.enabled = true
                
                } else {
                    
                    //TODO:Staticメソッド作る
                    let alert:UIAlertController = UIAlertController(title:"確認",
                                                                  message:"10問解きました。",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let defaultAction:UIAlertAction = UIAlertAction(title:"OK",
                        style: UIAlertActionStyle.Default,
                        handler:{
                            (action:UIAlertAction!) -> Void in
                            
                    })
                    
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.solveTimes = 0;
                    sender.enabled = true
                }
                
        })
        
    }
    
    func setQuestion() {
        
        self.quizDic = WordsModel().getOneQuiz()
        self.quizView.setupLabelWithQuizDic(self.quizDic)
        self.speachText(self.quizDic["question"]!)
        
    }
    
    private func checkAnswer(userAnswer :String,
                             quizAnswer :String,
                           quizQuestion :String) {
        
        let answerModel = AnswersModel()
        var wordModel = WordsModel()
        
        answerModel.answer_duration = "10s"
        answerModel.answer_date = self.getCurrentDateTime()
        
        if userAnswer == quizAnswer {
            
            print("CORRECT")
            quizView.check_image.image = UIImage(named:"correct")!
            answerModel.isCorrect = "true"
            self.soundAnswerCheck(correct: true)
            
        } else {
            
            print("WRONG")
            quizView.check_image.image = UIImage(named:"wrong")!
            answerModel.isCorrect = "false"
            self.soundAnswerCheck(correct: false)
        }
        
        quizView.check_image.alpha = 1
        
        answerModel.saveAnswer(answerModel)
        wordModel = wordModel.getWord(quizQuestion)!
        answerModel.setAnswer(answerModel, word: wordModel)
        print(wordModel)
        
    }
    
    private func getCurrentDateTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/hh/mm/ss"
        let date = dateFormatter.stringFromDate(NSDate())
        return date
    }
    
    //MARK:サウンド系
    private func soundAnswerCheck(correct isCorrect: Bool) {
        
        if(isCorrect){
            
            do {
                try correctAudioPlayer = AVAudioPlayer(contentsOfURL: correctSound)
                correctAudioPlayer.prepareToPlay()
                correctAudioPlayer.play()
                
            } catch { print("error") }
            
        } else {
            
            do {
                try wrongAudioPlayer = AVAudioPlayer(contentsOfURL: wrongSound)
                wrongAudioPlayer.prepareToPlay()
                wrongAudioPlayer.play()
                
            } catch { print("error") }
        }
        
    }
    
    //MARK: Text to Speech
    private func speachText(string: String) {
        
        let synth = AVSpeechSynthesizer()
        let engVoice = AVSpeechSynthesisVoice(language:"en-US")
        
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: string)
        myUtterance.rate = 0.5
        myUtterance.voice = engVoice
        synth.speakUtterance(myUtterance)
        
    }
    
    
    
    //MARK:LevelSelectView
    func addLevelSelectView() {
        
        let bundle = NSBundle(forClass: LevelSelectView.self)
        levelSelectView = bundle.loadNibNamed("LevelSelectView", owner: nil, options: nil)[0] as! LevelSelectView
        levelSelectView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(levelSelectView)
        
        for button in levelSelectView.levelButtonsArray {
            button.addTarget(self, action: #selector(self.tapLevelButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    @IBAction func tapLevelButton(sender: UIButton) {
        
        print(sender.tag)
        
        if(quizView==nil) {
            self.addQuizView()
        }
        
        quizView.hidden = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
}
