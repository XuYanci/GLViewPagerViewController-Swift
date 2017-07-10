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
    open var dataSource: GLViewPagerViewControllerDataSource?
    
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
    internal var contentViewControllers:[UIViewController] = []
    internal var contentViews:[UIView] = []
    internal var tabViews:[UIView] = []
    //internal var datasouceHas = _datasourceHas(numberOfTabsForViewPager: false, viewForTabIndex: false, contentViewControllerForTabAtIndex: false, contentViewForTabAtIndex: false)
    //internal var delegateHas = _delegateHas(didChangeTabToIndex: false, willChangeTabToIndex: false, widthForTabIndex: false)
    
    
    // MARK: - const
    let  kTabTagBegin:Int = 0xA0
    let  kTabHeight:CGFloat = 44.0
    
    
    struct _datasourceHas{
        static var numberOfTabsForViewPager:Bool =  false
        static var viewForTabIndex:Bool = false
        static var contentViewControllerForTabAtIndex:Bool = false
        static var contentViewForTabAtIndex:Bool = false
    }
    
    struct _delegateHas{
        static var didChangeTabToIndex:Bool = false
        static var willChangeTabToIndex:Bool = false
        static var  widthForTabIndex:Bool = false
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
        self.view .addSubview(UIView.init())
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
        if self.supportArabic {
            let index:Int = self.contentViewControllers .index(of: viewController)!
            if index == self.contentViewControllers.count - 1 {
                return nil
            }
            return self.contentViewControllers[index + 1]
        }
        
        let index:Int = self.contentViewControllers .index(of: viewController)!
        if index == 0 {
            return nil
        }
        return self.contentViewControllers[index - 1]
    }
    
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.supportArabic {
            let index:Int = self.contentViewControllers .index(of: viewController)!
            if index == 0 {
                return nil
            }
            return self.contentViewControllers[index - 1]
        }
        
        let index:Int = self.contentViewControllers .index(of: viewController)!
        if index == self.contentViewControllers.count - 1 {
            return nil
        }
        return self.contentViewControllers[index + 1]
        
    }
    
    // MARK: - Delegate
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentPageIndex:Int = self.contentViewControllers .index(of: self.pageViewController.viewControllers![0])!
            let prevPageIndex:Int = self.contentViewControllers .index(of: previousViewControllers[0])!
            self ._setActiveTabIndex(tabIndex: currentPageIndex)
            self ._caculateTabOffsetWidth(pageIndex: currentPageIndex)
            _currentPageIndex = currentPageIndex
            if _delegateHas.didChangeTabToIndex {
                delegate?.didChangeTabToIndex?(self, index: currentPageIndex, fromTabIndex: prevPageIndex)
            }
            
            if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_WhileScrolling {
                _enableTabAnimationWhileScrolling = false
            }
        }
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_WhileScrolling {
            _enableTabAnimationWhileScrolling = true
        }
    }
    
    open  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_WhileScrolling {
            _enableTabAnimationWhileScrolling = false
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_WhileScrolling && _enableTabAnimationWhileScrolling {
            let scale:CGFloat = fabs(scrollView.contentOffset.x - scrollView.frame.size.width) / scrollView.frame.size.width
            var offset:CGFloat = 0
            var indicationAnimationWidth:CGFloat = 0
            let currentPageIndex:Int = _currentPageIndex
            var indicatorViewFrame:CGRect = self ._caculateTabViewFrame(tabIndex: currentPageIndex)
            // left to right
            if scrollView.contentOffset.x - scrollView.frame.size.width > 0 {
                if self.supportArabic {
                    offset = -leftTabOffsetWidth * scale
                    indicationAnimationWidth = CGFloat(indicatorViewFrame.size.width + leftMinusCurrentWidth * scale)
                }
                else {
                    offset = rightTabOffsetWidth * scale
                    indicationAnimationWidth = CGFloat(indicatorViewFrame.size.width + rightMinusCurrentWidth * scale)
                }
                
                if _delegateHas.willChangeTabToIndex {
                    if self.supportArabic {
                        delegate?.willChangeTabToIndex?(self, index: currentPageIndex == 0 ? 0 : currentPageIndex - 1, fromTabIndex: currentPageIndex, progress: scale)
                    }
                    else {
                        delegate?.willChangeTabToIndex?(self, index: (currentPageIndex + 1 > self.tabViews.count - 1) ? currentPageIndex : currentPageIndex + 1, fromTabIndex: currentPageIndex, progress: scale)
                    }
                }
            }
            // right to left
            else {
                if self.supportArabic {
                    offset = rightTabOffsetWidth * scale
                    indicationAnimationWidth = indicatorViewFrame.size.width + rightMinusCurrentWidth * scale
                }
                else {
                    offset = -leftTabOffsetWidth * scale
                    indicationAnimationWidth = indicatorViewFrame.size.width + leftMinusCurrentWidth * scale
                }
                
                if _delegateHas.willChangeTabToIndex {
                    if self.supportArabic {
                        delegate?.willChangeTabToIndex?(self, index: currentPageIndex == self.contentViewControllers.count - 1 ? self.contentViewControllers.count - 1 : currentPageIndex + 1, fromTabIndex: currentPageIndex, progress: scale)
                    }
                    else {
                        delegate?.willChangeTabToIndex?(self, index: currentPageIndex == 0 ? 0 : currentPageIndex - 1, fromTabIndex: currentPageIndex, progress: scale)
                    }
                }
            }
            indicatorViewFrame.origin.x += offset
            indicatorViewFrame.size.width = indicationAnimationWidth
            self.indicatorView.frame = indicatorViewFrame
        }
    }
    
    // MARK: - User Events
    func tapInTabView(tapGR:UIGestureRecognizer) -> Void {
        let tabIndex = (tapGR.view?.tag)! - kTabTagBegin
        self ._selectTab(tabIndex: tabIndex, animate: false)
    }
    
    
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
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }

        
        self._setNeedsReload()
    }
    
    open func setDataSource(newDataSource:GLViewPagerViewControllerDataSource) -> Void {
        self.dataSource = newDataSource
        
        _datasourceHas.numberOfTabsForViewPager = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.numberOfTabsForViewPager(_:)))
       
        _datasourceHas.contentViewForTabAtIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.contentViewForTabAtIndex(_:index:)))
        
        _datasourceHas.viewForTabIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.viewForTabIndex(_:index:)))
       
        _datasourceHas.contentViewControllerForTabAtIndex = newDataSource.responds(to: #selector(GLViewPagerViewControllerDataSource.contentViewControllerForTabAtIndex(_:index:)))
        
        self ._setNeedsReload()
    }
    
    open func setDelegate(newDelegate:GLViewPagerViewControllerDelegate) -> Void {
        self.delegate = newDelegate
        
        _delegateHas.didChangeTabToIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.didChangeTabToIndex(_:index:fromTabIndex:)))
        
        _delegateHas.willChangeTabToIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.willChangeTabToIndex(_:index:fromTabIndex:progress:)))
        
        _delegateHas.widthForTabIndex = newDelegate.responds(to: #selector(GLViewPagerViewControllerDelegate.widthForTabIndex(_:index:)))
    }
    
    func reloadData() -> Void {
        
        // Set ui control property
        self.indicatorView.backgroundColor = self.indicatorColor
        
        // Clear tab subviews
        self.tabViews .removeAll()
        for (_,element) in self.tabContentView.subviews.enumerated() {
            element.removeFromSuperview()
        }
        
        // Fill tab
        var numberOfTabs:Int! = 0
        if _datasourceHas.numberOfTabsForViewPager {
            numberOfTabs = dataSource?.numberOfTabsForViewPager!(self)
        }
        
        if _datasourceHas.viewForTabIndex {
            
            // Add indicator view
            if !self.tabContentView.subviews .contains(self.indicatorView) && numberOfTabs > 0{
                self.tabContentView .addSubview(self.indicatorView)
            }
            
            var preTabView:UIView?
            var tabContentWidth:CGFloat = 0.0
         
            for index in 0 ... numberOfTabs - 1 {
                var tabView:UIView! = UIView.init()
                if self.supportArabic {
                    tabView = (self.dataSource?.viewForTabIndex!(self, index: numberOfTabs - index - 1))
                    assert(tabView .isKind(of: UIView.self), "This is not an UIView subclass")
                    self.tabContentView .addSubview(tabView)
                    self.tabViews .insert(tabView, at: 0)
                    tabView.tag = kTabTagBegin + (numberOfTabs - index - 1)
                }
                else {
                    tabView = dataSource?.viewForTabIndex!(self, index: index)
                    assert(tabView .isKind(of: UIView.self), "This is not an UIView subclass")
                    self.tabContentView .addSubview(tabView)
                    self.tabViews .append(tabView)
                    tabView.tag = kTabTagBegin + index
                }
                
                tabView.isUserInteractionEnabled = true
                tabView .addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapInTabView(tapGR:))))
            
                if preTabView == nil {
                    var rect:CGRect = tabView.frame
                    rect.size.width = self.fixTabWidth ? self.tabWidth : self ._getTabWidthAtIndex(tabIndex: index)
                    rect.size.height = self.tabHeight
                    rect.origin.x = self.leadingPadding
                    rect.origin.y = 0
                    tabView.frame = rect
                    preTabView = tabView
                    tabContentWidth +=  self.fixTabWidth ? (self.tabWidth + self.leadingPadding) : (self._getTabWidthAtIndex(tabIndex: self.supportArabic ? 0 : index) + self.leadingPadding)
                }
                else {
                    var rect:CGRect = tabView.frame
                    rect.size.width = self.fixTabWidth ? self.tabWidth : self ._getTabWidthAtIndex(tabIndex: self.supportArabic ? 0 : index)
                    rect.size.height = self.tabHeight
                    rect.origin.x = preTabView!.frame.maxX + self.padding
                    rect.origin.y = 0
                    tabView.frame = rect
                    preTabView = tabView
                    tabContentWidth += (self.fixTabWidth ? self.tabWidth : self._getTabWidthAtIndex(tabIndex: self.supportArabic ? 0 : index)) + self.padding
                }
                
                if index == numberOfTabs - 1 {
                    tabContentWidth += self.trailingPadding
                }
            }
            self.tabContentView.contentSize = CGSize(width: tabContentWidth, height: kTabHeight)
        }
        
        self.contentViews .removeAll()
        self.contentViewControllers.removeAll()
        
        if _datasourceHas.contentViewControllerForTabAtIndex {
            for i in 0 ... numberOfTabs - 1 {
               var viewController:UIViewController!
                if self.supportArabic {
                    viewController = self.dataSource?.contentViewControllerForTabAtIndex!(self, index: numberOfTabs - i - 1)
                    assert(viewController .isKind(of: UIViewController.self), "This is not an UIViewController subclass")
                    self.contentViewControllers .insert(viewController, at: 0)
                }
                else {
                    viewController = self.dataSource?.contentViewControllerForTabAtIndex!(self, index: i)
                    assert(viewController .isKind(of: UIViewController.self), "This is not an UIViewController subclass")
                    self.contentViewControllers .append(viewController)
                }
            }
            
            assert(self.defaultDisplayPageIndex <= self.contentViewControllers.count - 1, "Default display page index is bigger than amount of view controller")
            
            self._setActivePageIndex(pageIndex: self.defaultDisplayPageIndex)
            self._setActiveTabIndex(tabIndex: self.defaultDisplayPageIndex)
            self._caculateTabOffsetWidth(pageIndex: self.defaultDisplayPageIndex)
            self._currentPageIndex = self.defaultDisplayPageIndex
            
            if _delegateHas.didChangeTabToIndex {
                delegate?.didChangeTabToIndex!(self, index: _currentPageIndex, fromTabIndex: self.defaultDisplayPageIndex)
            }
        }
    
        else if _datasourceHas.contentViewForTabAtIndex {
            // MARK: - TODO
        }
        _needsReload = false
    }
    
    open func tabViewAtIndex(index:Int) -> UIView {
        return self.tabViews[index]
    }
    
    func _selectTab(tabIndex:Int,animate:Bool) -> Void {
        let prevPageIndex:Int = _currentPageIndex
        self._disableViewPagerScroll()
        self._setActivePageIndex(pageIndex: tabIndex)
        self._setActiveTabIndex(tabIndex: tabIndex)
        self._caculateTabOffsetWidth(pageIndex: tabIndex)
        _currentPageIndex = tabIndex
        _enableTabAnimationWhileScrolling = false
        self ._enableViewPagerScroll()
        
        if _delegateHas.didChangeTabToIndex {
            delegate?.didChangeTabToIndex!(self, index: _currentPageIndex, fromTabIndex: prevPageIndex)
        }
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
        let topLayoutGuide:CGFloat = self.topLayoutGuide.length
        let bottomLayoutGuide:CGFloat = self.bottomLayoutGuide.length
        
        var tabContentViewFrame:CGRect = self.tabContentView.frame
        tabContentViewFrame.size.width = self.view.bounds.size.width
        tabContentViewFrame.size.height = kTabHeight
        tabContentViewFrame.origin.x = 0
        tabContentViewFrame.origin.y = topLayoutGuide
        self.tabContentView.frame = tabContentViewFrame
        
        var pageViewCtrlFrame:CGRect = self.pageViewController.view.frame
        pageViewCtrlFrame.size.width = self.view.bounds.size.width
        pageViewCtrlFrame.size.height = self.view.bounds.size.height - topLayoutGuide - bottomLayoutGuide - self.tabContentView.frame.height
        pageViewCtrlFrame.origin.x = 0
        pageViewCtrlFrame.origin.y = topLayoutGuide + self.tabContentView.frame.height
        self.pageViewController.view.frame = pageViewCtrlFrame
    }
    
    func _setActiveTabIndex(tabIndex:Int) -> Void {
        assert(tabIndex <= self.tabViews.count - 1, "Default display page index is bigger than amount of view ocntroller")
        
        let frameofTabView:CGRect = self ._caculateTabViewFrame(tabIndex: tabIndex)
        if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_End ||
            self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_WhileScrolling{
            UIView .animate(withDuration: TimeInterval(self.animationTabDuration), animations: { 
                self.indicatorView.frame = frameofTabView
            })
        }
        else if self.tabAnimationType == GLTabAnimationType.GLTabAnimationType_None {
            self.indicatorView.frame = frameofTabView
        }
        
        let tabView:UIView = self.tabViews[tabIndex] 
        var frame:CGRect = tabView.frame
        
        frame.origin.x += frame.width / 2
        frame.origin.x -= self.view.frame.width / 2
        frame.size.width = self.view.frame.width
        
        if frame.origin.x < 0 {
            frame.origin.x = 0
        }
        if frame.origin.x + frame.width > self.tabContentView.contentSize.width {
            frame.origin.x = self.tabContentView.contentSize.width - self.view.frame.width
        }
        
        DispatchQueue.main.async {
           self.tabContentView .scrollRectToVisible(frame, animated: true)
        }
    }
    
    
    func _setActivePageIndex(pageIndex:Int) -> Void {
        assert(pageIndex < self.contentViewControllers.count, "Default display page index is bigger than amount of view controller")
        
        var direction:UIPageViewControllerNavigationDirection = self.supportArabic ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse
        if pageIndex > _currentPageIndex {
            direction = self.supportArabic ? UIPageViewControllerNavigationDirection.reverse : UIPageViewControllerNavigationDirection.forward
        }
        
        self.pageViewController .setViewControllers([self.contentViewControllers[pageIndex]], direction: direction, animated: true, completion: nil)
        
    }
    
    func _getTabWidthAtIndex(tabIndex:Int) -> CGFloat {
        var tabWidth:CGFloat = 0
        let tabView:UIView = self.tabViews[tabIndex]
        if _delegateHas.widthForTabIndex {
           tabWidth = (delegate?.widthForTabIndex?(self, index: tabView.tag - kTabTagBegin))!
        }
        return tabWidth == 0 ? tabView.intrinsicContentSize.width : tabWidth
    }
 
    func _caculateTabViewFrame(tabIndex:Int) -> CGRect {
        var frameOfTabView:CGRect = CGRect.zero
        
        if self.fixTabWidth {
            if self.supportArabic {
                frameOfTabView.origin.x = self.tabContentView.contentSize.width - ( CGFloat(tabIndex) * self.tabWidth  + (CGFloat(tabIndex) * self.padding) + self.trailingPadding) - self.tabWidth
                frameOfTabView.origin.y = self.tabHeight - self.indicatorHeight
                frameOfTabView.size.height = self.indicatorHeight
                frameOfTabView.size.width = self.tabWidth
            }
            else {
                frameOfTabView.origin.x =  CGFloat(tabIndex) * self.tabWidth + (CGFloat(tabIndex) * self.padding) + self.leadingPadding
                frameOfTabView.origin.y = self.tabHeight - self.indicatorHeight
                frameOfTabView.size.height = self.indicatorHeight
                frameOfTabView.size.width = self.tabWidth
            }
        }
        else {
            if self.supportArabic {
                let previousTabView:UIView = (tabIndex < self.tabViews.count - 1) ? self.tabViews[tabIndex + 1] : UIView()
                var x:CGFloat = 0
                if tabIndex == self.tabViews.count - 1 {
                    x += self.leadingPadding
                }
                else {
                    x += self.padding
                }
                
                x += previousTabView.frame.maxX
                frameOfTabView = CGRect.zero
                frameOfTabView.origin.x = x
                frameOfTabView.origin.y = self.tabHeight - self.indicatorHeight
                frameOfTabView.size.height = self.indicatorHeight
                frameOfTabView.size.width = self ._getTabWidthAtIndex(tabIndex: tabIndex)
                
            }
            else {
                let previousTabView:UIView = tabIndex > 0 ? self.tabViews[tabIndex - 1] : UIView()
                var x:CGFloat = 0
                if tabIndex == 0 {
                    x += self.leadingPadding
                }
                else {
                    x += self.padding
                }
                x += previousTabView.frame.maxX
                frameOfTabView = CGRect.zero
                frameOfTabView.origin.x = x
                frameOfTabView.origin.y = self.tabHeight - self.indicatorHeight
                frameOfTabView.size.height = self.indicatorHeight
                frameOfTabView.size.width = self._getTabWidthAtIndex(tabIndex: tabIndex)
            }
            
        }
        return frameOfTabView
    }
   
    
    func _caculateTabOffsetWidth(pageIndex:Int) -> Void {
        let currentTabIndex:Int = pageIndex
        let currentTabView:UIView = self.tabViews[currentTabIndex]
        let previousTabView:UIView? = currentTabIndex > 0 ? self.tabViews[currentTabIndex - 1] : nil
        let afterTabView:UIView? = (currentTabIndex < self.tabViews.count - 1) ? self.tabViews[currentTabIndex + 1] : nil
        
        if currentTabIndex == 0 {
            leftTabOffsetWidth = self.leadingPadding
            rightTabOffsetWidth = (afterTabView?.frame.minX)! - currentTabView.frame.minX
            leftMinusCurrentWidth = 0
            rightMinusCurrentWidth = (afterTabView?.frame.width)! - currentTabView.frame.width
        }
        else if (currentTabIndex == self.tabViews.count - 1) {
            leftTabOffsetWidth = currentTabView.frame.minX - (previousTabView?.frame.minX)!
            rightTabOffsetWidth = self.trailingPadding
            leftMinusCurrentWidth = (previousTabView?.frame.width)! - currentTabView.frame.width
            rightTabOffsetWidth = 0
        }
        else {
            leftTabOffsetWidth = currentTabView.frame.minX - (previousTabView?.frame.minX)!
            rightTabOffsetWidth = (afterTabView?.frame.minX)! - currentTabView.frame.minX
            leftMinusCurrentWidth = (previousTabView?.frame.width)! - currentTabView.frame.width
            rightMinusCurrentWidth = (afterTabView?.frame.width)! - currentTabView.frame.width
        }
    }
    

    
    func _disableViewPagerScroll() -> Void {
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    func _enableViewPagerScroll() -> Void {
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                //Do something with fruit
                scrollView.isScrollEnabled = true
            }
        }
    }
}
