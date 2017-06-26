//
//  GLViewPagerViewController.swift
//  GLViewPagerViewControllerForSwift
//
//  Created by Yanci on 2017/6/26.
//  Copyright © 2017年 Yanci. All rights reserved.
//

import UIKit


public enum GLIndicatorType:Int {
    case GLIndicatorType_Line = 0
    case GLIndicatorType_Rect = 1
}

public enum GLTabAnimationType:Int {
     /* no animation */
    case GLTabAnimationType_None = 0
    /* animation while scrolling */
    case GLTabAnimationType_WhileScrolling = 1
    /* animation when ending */
    case GLTabAnimationType_End = 2
}



// MARK: - Protocols 
@objc public protocol GLViewPagerViewControllerDataSource:NSObjectProtocol {
    @objc optional func numberOfTabsForViewPager(_ viewPager:GLViewPagerViewController)
    @objc optional func viewForTabIndex(_ viewPager:GLViewPagerViewController, index: Int) -> UIView
    @objc optional func contentViewControllerForTabAtIndex(_ viewPager:GLViewPagerViewController, index: Int) -> UIViewController
    @objc optional func contentViewForTabAtIndex(_ viewPager:GLViewPagerViewController, index: Int) -> UIView
}

@objc public protocol GLViewPagerViewControllerDelegate:NSObjectProtocol {
    @objc optional func didChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int)
    @objc optional func willChangeTabToIndex(_ viewPager: GLViewPagerViewController, index: Int, fromTabIndex: Int, progress: CGFloat)
    @objc optional func widthForTabIndex(_ viewPager: GLViewPagerViewController, index: Int) -> CGFloat
}


open class GLViewPagerViewController: UIViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate {
    
    
    // MARK: - public properties
    open var dataSource: GLViewPagerViewControllerDataSource!
    
    open var delegate: GLViewPagerViewControllerDelegate?
    
    open var indicatorColor: UIColor = UIColor.blue
    
    open var fixTabWidth: Bool = false
    
    open var tabWidth:CGFloat = 128.0
    
    open var tabHeight:CGFloat = 44.0
    
    open var indicatorHeight:CGFloat = 2.0
    
    open var indicatorWidth:CGFloat = 128.0
    
    open var fixIndicatorWidth:Bool = false
    
    open var padding:CGFloat = 0.0
    
    open var leadingPadding:CGFloat = 0.0
    
    open var trailingPadding:CGFloat = 0.0
    
    open var defaultDisplayPageIndex = 0
    
    open var animationTabDuration:CGFloat = 0.3
    
    open var tabAnimationType:GLTabAnimationType = GLTabAnimationType.GLTabAnimationType_None
    
    open var supportArabic:Bool = false
    
    // MARK: - ui properties
    internal var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    internal var tabContentView: UIScrollView = UIScrollView()
    internal var indicatorView: UIView = UIView();
    
    
    // MARK: - cache properties
    internal var _needsReload: Bool = false
    internal var leftTabOffsetWidth: CGFloat = 0
    internal var rightTabOffsetWidth: CGFloat = 0
    internal var leftMinusCurrentWidth: CGFloat = 0
    internal var rightMinusCurrentWidth: CGFloat = 0
    internal var _currentPageIndex: Int = 0
    internal var _enableTabAnimationWhileScrolling:Bool = false
    internal var contentViewControllers:NSMutableArray = NSMutableArray()
    internal var contentViews:NSMutableArray = NSMutableArray()
    internal var tabViews:NSMutableArray = NSMutableArray()
    
    
    
    // MARK: - Life cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        self.view .addSubview(self.tabContentView)
        self.view .addSubview(self.pageViewController.view)
    }
    
    override open func viewWillLayoutSubviews() {
        self ._reloadDataIfNeed()
        self ._layoutSubviews()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    // MARK: - Data Source
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil;
    }
    
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil;
    }
    
    // MARK: - Delegate
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    open  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: - User Events
    
    // MARK: - Functions 
    func commonInit () {
        
    }
    
    func setDataSource() -> Void {
        
    }
    
    func setDelegate() -> Void {
        
    }
    
    func reloadData() -> Void {
        
    }
    
    func _setNeedsReload() -> Void {
        
    }
    
    func _reloadDataIfNeed() -> Void {
        
    }
    
    func _layoutSubviews() -> Void {
        
    }
    
    // MARK: - Notification 
    
    // MARK: - Getter and Setter 
    
    
}
