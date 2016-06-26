//
//  Static.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit
import AVFoundation

class Static:NSObject {
    
    //MARK: Text to Speech
    static func speachText(string: String) {
        
        let synth = AVSpeechSynthesizer()
        let engVoice = AVSpeechSynthesisVoice(language:"en-US")
        
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: string)
        myUtterance.rate = 0.5
        myUtterance.voice = engVoice
        synth.speakUtterance(myUtterance)
        
    }
    
    static func singleAlertViewController(title:String, message:String, actionTitle:String){
        
        let alert:UIAlertController = UIAlertController(title:title,
                                                        message:message,
                                                        preferredStyle: UIAlertControllerStyle.Alert)

        //Default 複数指定可
        let defaultAction:UIAlertAction = UIAlertAction(title: actionTitle,
                                                        style: UIAlertActionStyle.Default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            
        })
        
        alert.addAction(defaultAction)
        
        
        //表示。UIAlertControllerはUIViewControllerを継承している。
        //presentViewController(alert, animated: true, completion: nil)
    }
    
}