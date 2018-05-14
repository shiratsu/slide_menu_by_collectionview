//
//  InfiniteScrollView.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/15.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView,UIScrollViewDelegate {

    // 1
    var viewObjects: [UIView]?
    var numPages: Int = 0
    
    // 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        delegate = self
    }
    

}
