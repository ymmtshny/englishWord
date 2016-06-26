//
//  ArticleViewController.swift
//  eWord
//
//  Created by Shinya Yamamoto on 2016/06/26.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var article: articleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK:ArticelView
    func addArticelView() {
        
        let bundle = NSBundle(forClass: articleView.self)
        article = bundle.loadNibNamed("articleView", owner: nil, options: nil)[0] as! articleView
        article.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(article)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
