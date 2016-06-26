//
//  ViewController.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/05/20.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit
import RealmSwift


class WordListViewController: UIViewController  {

    @IBOutlet weak var wordListView:wordListTabelView!
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let config = Realm.Configuration(schemaVersion: 1)
        //Realm.Configuration.defaultConfiguration = config

       //self.addWordListTableView()
    }
    
    
    //MARK:単語リストtableView
    func addWordListTableView() {
        
        let bundle = NSBundle(forClass: wordListTabelView.self)
        wordListView = bundle.loadNibNamed("wordListTabelView", owner: nil, options: nil)[0] as! wordListTabelView
        wordListView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(wordListView)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
    


