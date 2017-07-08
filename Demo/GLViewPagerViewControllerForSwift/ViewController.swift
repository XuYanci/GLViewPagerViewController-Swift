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
        self.setDataSource(newDataSource: self)
        self.setDelegate(newDelegate: self)
        self.padding = 10
        self.leadingPadding = 10
        self.trailingPadding = 10
        self.defaultDisplayPageIndex = 0
        self.tabAnimationType = GLTabAnimationType.GLTabAnimationType_WhileScrolling
        self.indicatorColor = UIColor.init(colorLiteralRed: 255.0 / 255.0, green: 205.0 / 255.0, blue: 0.0, alpha: 1.0)
        self.supportArabic = false
        self.fixTabWidth = false
        
        
        self.viewControllers = [
            GLPresentViewController.init(title: "Page One"),
            GLPresentViewController.init(title: "Page Two"),
            GLPresentViewController.init(title: "Page Three"),
            GLPresentViewController.init(title: "Page Four"),
            GLPresentViewController.init(title: "Page Five"),
            GLPresentViewController.init(title: "Page Six"),
            GLPresentViewController.init(title: "Page seven"),
            GLPresentViewController.init(title: "Page Eight"),
            GLPresentViewController.init(title: "Page Nine"),
            GLPresentViewController.init(title: "Page Ten"),
            GLPresentViewController.init(title: "Page Eleven"),
            GLPresentViewController.init(title: "Page Twelve")
        ]
        
        self.tabTitles = [ "Page One",
                           "Page Two" ,
                           "Page Three" ,
                           "Page Four",
                           "Page Five",
                           "Page Six",
                           "Page Seven",
                           "Page Eight",
                           "Page Nine",
                           "Page Ten",
                           "Page Eleven",
                           "Page Twelve"]

        
    }

    // MARK: - GLViewPagerViewControllerDataSource
    func numberOfTabsForViewPager(_ viewPager: GLViewPagerViewController) -> Int {
        return self.viewControllers.count
    }
    
    func viewForTabIndex(_ viewPager: GLViewPagerViewController, index: Int) -> UIView {
        let label:UILabel = UILabel.init()
        label.text = self.tabTitles.object(at: index) as? String
        label.textColor = UIColor.init(colorLiteralRed: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        label.textAlignment = NSTextAlignment.center
        label.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        return label
    }
    
    func contentViewControllerForTabAtIndex(_ viewPager: GLViewPagerViewController, index: Int) -> UIViewController {
        return self.viewControllers.object(at: index) as! UIViewController
    }
    
    // MARK: - GLViewPagaerViewControllerDelegate
    func didChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int) {
        let prevLabel:UILabel = viewPager.tabViewAtIndex(index: fromTabIndex) as! UILabel
        let currentLabel:UILabel = viewPager.tabViewAtIndex(index: index) as! UILabel
        prevLabel.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        currentLabel.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        prevLabel.textColor = UIColor.init(colorLiteralRed: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        currentLabel.textColor = UIColor.init(colorLiteralRed: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
    }
    
    func willChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int, progress: CGFloat) {
        if fromTabIndex == index {
            return;
        }
        
        let prevLabel:UILabel = viewPager.tabViewAtIndex(index: fromTabIndex) as! UILabel
        let currentLabel:UILabel = viewPager.tabViewAtIndex(index: index) as! UILabel
        prevLabel.transform = CGAffineTransform.identity.scaledBy(x: 1.0 - (0.1 * progress), y: 1.0 - (0.1 * progress))
        currentLabel.transform = CGAffineTransform.identity.scaledBy(x: 0.9 + (0.1 * progress), y: 0.9 + (0.1 * progress))
        currentLabel.textColor =  UIColor.init(colorLiteralRed: Float(0.3 + 0.2 * progress), green: Float(0.3 - 0.3 * progress), blue: Float(0.3 + 0.2 * progress), alpha: 1.0)
        prevLabel.textColor = UIColor.init(colorLiteralRed: Float(0.5 - 0.2 * progress), green: Float(0.0 + 0.3 * progress), blue: Float(0.5 - 0.2 * progress), alpha: 1.0)
    }
    
    func widthForTabIndex(_ viewPager: GLViewPagerViewController, index: Int) -> CGFloat {
        let prototypeLabel:UILabel = UILabel.init()
        prototypeLabel.text = self.tabTitles.object(at: index) as? String
        prototypeLabel.textAlignment = NSTextAlignment.center
        prototypeLabel.font = UIFont.systemFont(ofSize: 16.0)
        return prototypeLabel.intrinsicContentSize.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

