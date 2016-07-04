//
//  QuizViewController.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController, QuizViewDelegate, CheckAnswerViewDelegate, QuizResultViewDelegate {
    
    //UI
    @IBOutlet weak var quizView: QuizView!
    var levelSelectView:LevelSelectView!
    var checkAnswerView: CheckAnswerView!
    var quizResultView: QuizResultView!
    
    //音声関係
    var correctAudioPlayer = AVAudioPlayer()
    var wrongAudioPlayer = AVAudioPlayer()
    let correctSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("correct", ofType: "mp3")!)
    let wrongSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrong", ofType: "mp3")!)
    
    //データ
    var quizDic = [String:String]()
    var solveTimes = 0
    var correctTimes = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addQuizView()
        self.setQuestion()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setCheckAnswerView()
        self.setQuizResultView()
    }
    
    //MARK:クイズ結果のビュー
    func setQuizResultView() {
        
        self.quizResultView = QuizResultView.instance()
        self.quizResultView.delegate = self
        self.quizResultView.frame = self.view.frame
        self.quizResultView.hidden = true
        self.view.addSubview(self.quizResultView)
    }
    
    func showQuizResultView() {
        self.quizResultView.setResultViewWith(self.correctTimes, totalNumber: self.solveTimes)
        self.quizResultView.hidden = false
        self.solveTimes = 0
        self.correctTimes = 0
    }
    
    
    @IBAction func tapQuizResultViewOKButton(sender: UIButton) {
        self.quizResultView.hidden = true
    }
    
    
    //MARK:答え確認のビュー
    func setCheckAnswerView() {
        self.checkAnswerView = CheckAnswerView.instance()
        self.checkAnswerView.delegate = self
        self.checkAnswerView.frame = self.view.frame
        self.checkAnswerView.hidden = true
        self.view.addSubview(self.checkAnswerView)
    }
    
    
    func showCheckAnswerView() {
        self.checkAnswerView.engLabel.text = quizDic["question"]!
        self.checkAnswerView.jpLabel.text = quizDic["answer"]!
        self.checkAnswerView.hidden = false
    }
    
    @IBAction func tapOKButton(sender: UIButton) {
        self.quizView.check_image.alpha = 0
        self.checkAnswerView.hidden = true
        if(self.solveTimes < 10) {
            
            self.setQuestion()
            
        } else {
            
            self.showQuizResultView()
            
        }
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
        
        //１秒後にボタン押せるようにする。
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
           sender.enabled = true
        })
        
        
        solveTimes += 1;
        print("解答回数 \(solveTimes)")
        
        let userAnswer = sender.titleLabel?.text
        let quizAnswer = quizDic["answer"]!
        let quizEnglish = quizDic["question"]!
        
        //答え合わせと解答データを補保存
        let isCorret = self.checkAnswer(userAnswer!,quizAnswer: quizAnswer, quizQuestion: quizEnglish)
        
        if(isCorret) {
            
            UIView.animateWithDuration(1, animations: {
                
                self.quizView.check_image.alpha = 0
                
                }, completion: {(value: Bool) in })
            
        } else {
            
            self.showCheckAnswerView()
            return
        }
        
        if(self.solveTimes < 10) {
            
            self.setQuestion()
            
        } else {
            
            self.showQuizResultView()
            
        }
        
        
    
        
    }
    
    func setQuestion() {
        
        self.quizDic = WordsModel().getOneQuiz()
        self.quizView.setupLabelWithQuizDic(self.quizDic)
        self.speachText(self.quizDic["question"]!)
        
    }
    
    //答え合わせをするとともに解答データを保存する。
    private func checkAnswer(userAnswer :String,
                             quizAnswer :String,
                           quizQuestion :String) -> Bool{
        
        var isCorrect = false
        let answerModel = AnswersModel()
        var wordModel = WordsModel()
        
        answerModel.answer_duration = "10s"
        answerModel.answer_date = self.getCurrentDateTime()
        
        if userAnswer == quizAnswer {
            
            print("CORRECT")
            correctTimes += 1
            isCorrect = true
            quizView.check_image.image = UIImage(named:"correct")!
            answerModel.isCorrect = "true"
            self.soundAnswerCheck(correct: true)
            
            
        } else {
            
            print("WRONG")
            isCorrect = false
            quizView.check_image.image = UIImage(named:"wrong")!
            answerModel.isCorrect = "false"
            self.soundAnswerCheck(correct: false)
        }
        
        quizView.check_image.alpha = 1
        
        answerModel.saveAnswer(answerModel)
        wordModel = wordModel.getWord(quizQuestion)!
        answerModel.setAnswer(answerModel, word: wordModel)
        print(wordModel)
        
        return isCorrect
        
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
