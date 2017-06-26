//
//  ViewController.swift
//  GLViewPagerViewControllerForSwift
//
//  Created by Yanci on 2017/6/26.
//  Copyright © 2017年 Yanci. All rights reserved.
//




import UIKit


class GLPresentViewController: UIViewController {
    
    var presentLabel: UILabel = UILabel()
    
    internal var _title : NSString = "Page Zero"
    internal var _setupSubViews:Bool = false
  
    init(title : NSString) {
        _title = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentLabel.text = self._title as String
        self.presentLabel.sizeToFit()
        self.view .addSubview(self.presentLabel)
        self.presentLabel.center = self.view.center
    }
    
    override func viewWillLayoutSubviews() {
        self.presentLabel.center = self.view.center
    }
   
    
    
}


class ViewController: GLViewPagerViewController,GLViewPagerViewControllerDataSource,GLViewPagerViewControllerDelegate {

    
    
    // MARK: - cache properties
    var viewControllers: NSArray = NSArray()
    var tabTitles: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Paged Tabs"
        self.dataSource = self;
        self.delegate = self;
        self.padding = 10
        self.leadingPadding = 10
        self.trailingPadding = 10
        self.defaultDisplayPageIndex = 0
        self.tabAnimationType = GLTabAnimationType.GLTabAnimationType_WhileScrolling
        self.indicatorColor = UIColor.init(colorLiteralRed: 255.0 / 255.0, green: 205.0 / 255.0, blue: 0.0, alpha: 1.0)
        self.supportArabic = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

