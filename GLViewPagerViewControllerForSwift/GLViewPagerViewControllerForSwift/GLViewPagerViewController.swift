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
    @objc optional func numberOfTabsForViewPager(_ viewPager:GLViewPagerViewController) -> Int
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
    internal var datasouceHas = _datasourceHas(numberOfTabsForViewPager: false, viewForTabIndex: false, contentViewControllerForTabAtIndex: false, contentViewForTabAtIndex: false)
    internal var delegateHas = _delegateHas(didChangeTabToIndex: false, willChangeTabToIndex: false, widthForTabIndex: false)
    
    
    struct _datasourceHas{
        var numberOfTabsForViewPager:Bool =  false
        var viewForTabIndex:Bool = false
        var contentViewControllerForTabAtIndex:Bool = false
        var contentViewForTabAtIndex:Bool = false
    }
    
    struct _delegateHas{
        var didChangeTabToIndex:Bool = false
        var willChangeTabToIndex:Bool = false
        var  widthForTabIndex:Bool = false
    }

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
        self.indicatorColor = UIColor.blue
        self.fixTabWidth = true
        self.tabWidth = 128.0
        self.tabHeight = 44.0
        self.indicatorHeight = 2.0
        self.padding = 0.0
        self.indicatorWidth = 128.0
        self.fixIndicatorWidth = true
        self.leadingPadding = 0.0
        self.trailingPadding = 0.0
        self.defaultDisplayPageIndex = 0
        self.tabAnimationType = GLTabAnimationType.GLTabAnimationType_None
        self.animationTabDuration = 0.3
        self._setNeedsReload()
    }
    
    func setDataSource(newDataSource:GLViewPagerViewControllerDataSource) -> Void {
        self.dataSource = newDataSource
        
        datasouceHas.numberOfTabsForViewPager = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.numberOfTabsForViewPager(_:)))
       
        datasouceHas.contentViewForTabAtIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.contentViewForTabAtIndex(_:index:)))
        
        datasouceHas.viewForTabIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.viewForTabIndex(_:index:)))
       
        datasouceHas.contentViewControllerForTabAtIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.contentViewControllerForTabAtIndex(_:index:)))
        
        self ._setNeedsReload()
    }
    
    func setDelegate(newDelegate:GLViewPagerViewControllerDelegate) -> Void {
        self.delegate = newDelegate
        
        delegateHas.didChangeTabToIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.didChangeTabToIndex(_:index:fromTabIndex:)))
        
        delegateHas.willChangeTabToIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.willChangeTabToIndex(_:index:fromTabIndex:progress:)))
        
        delegateHas.widthForTabIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.widthForTabIndex(_:index:)))
    }
    
    func reloadData() -> Void {
        
    }
    
    func _setNeedsReload() -> Void {
        _needsReload = true
        self.view.setNeedsLayout()
    }
    
    func _reloadDataIfNeed() -> Void {
        if _needsReload {
            self .reloadData()
        }
    }
    
    func _layoutSubviews() -> Void {
        
    }
    
    open func tabViewAtIndex(index:Int) -> UIView {
        return self.tabViews.object(at: index) as! UIView
    }
    
    // MARK: - Notification 
    
    // MARK: - Getter and Setter 
    
    
}
