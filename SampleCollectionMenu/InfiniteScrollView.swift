//
//  InfiniteScrollView.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/15.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit


/// scrollの方向を定義
///
/// - left: go foward
/// - right: oposit go foward
enum ScrollDirection : Int{
    case left = 1
    case right = 2
}


/// action of scroll
/// basically use this delegate after scroll
protocol ScrollActionDelegate: class{
    
    
    /// scroll後のアクションを定義
    ///
    /// - Parameter direction: <#direction description#>
    func afterScroll(_ direction: ScrollDirection)
}


class InfiniteScrollView: UIScrollView,UIScrollViewDelegate {

    // 1
    var viewObjects: [UIView]?
    lazy var numPages: Int = 0
    fileprivate lazy var screenWidth : CGFloat = UIScreen.main.bounds.width
    fileprivate lazy var lastOffsetX: CGFloat = 0
    
    weak var actionDelegate: ScrollActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initScrollView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScrollView()
    }
    
    fileprivate func initScrollView(){
        
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        scrollsToTop = false
        delegate = self
        showsVerticalScrollIndicator = false
    }
    
    // 3
    func setup() {
        guard superview != nil else { return }
        
        contentSize = CGSize(width: (frame.size.width * (CGFloat(numPages) + 2)), height: frame.size.height)
        
        loadScrollViewWithPage(0)
        loadScrollViewWithPage(1)
        loadScrollViewWithPage(2)
        
        var newFrame = frame
        newFrame.origin.x = newFrame.size.width
        newFrame.origin.y = 0
        scrollRectToVisible(newFrame, animated: false)
        
        lastOffsetX = frame.origin.x
        
        layoutIfNeeded()
    }
    
    // 4
    private func loadScrollViewWithPage(_ page: Int) {
        if page < 0 { return }
        if page >= numPages + 2 { return }
        
        var index = 0
        
        if page == 0 {
            index = numPages - 1
        } else if page == numPages + 1 {
            index = 0
        } else {
            index = page - 1
        }
        
        let view = viewObjects?[index]
        
        var newFrame = frame
        newFrame.size.width = screenWidth
        newFrame.origin.x = screenWidth * CGFloat(page)
        newFrame.origin.y = 0
        view?.frame = newFrame
        
        if view?.superview == nil {
            addSubview(view!)
        }
        
        layoutIfNeeded()
    }
    
    // 5
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = frame.size.width
        let page = floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1
        
        loadScrollViewWithPage(Int(page - 1))
        loadScrollViewWithPage(Int(page))
        loadScrollViewWithPage(Int(page + 1))
    }
    
    // 6
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = frame.size.width
        let page : Int = Int(floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1)
        
        // 方向を決定する
        if lastOffsetX > contentOffset.x{
            // 後ろ
            actionDelegate?.afterScroll(.right)
        }else{
            // 前
            actionDelegate?.afterScroll(.left)
        }
        
        if page == 0 {
            contentOffset = CGPoint(x: pageWidth*(CGFloat(numPages)), y: 0)
        } else if page == numPages+1 {
            contentOffset = CGPoint(x: pageWidth, y: 0)
        }
        
        lastOffsetX = contentOffset.x
    }
    

}
