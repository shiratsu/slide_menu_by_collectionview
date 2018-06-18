//
//  SlidePagingProtocol.swift
//  shotworks_customer
//
//  Created by 平塚 俊輔 on 2018/06/03.
//  Copyright © 2018年 ‚àö√á≈ì√Ñ‚Äö√¢‚Ä¢‚àö√á¬¨‚àû‚àö‚àÇ ‚Äö√Ñ‚àû‚àö‚àè‚àö¬ß‚àö√£¬¨‚à´‚àö√Ü. All rights reserved.
//

import UIKit

extension UICollectionView{
    
    func validate(indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections {
            return false
        }
        
        if indexPath.row >= numberOfItems(inSection: indexPath.section) {
            return false
        }
        
        return true
    }
}

/// scrollの方向を定義
///
/// - left: go foward
/// - right: oposit go foward
enum ScrollDirection : Int{
    case `default` = 0
    case left = 1
    case right = 2
}

enum ScrollPosition : Int{
    case `default` = 0
    case zero = 1
    case limit = 2
}

protocol SlidePagingProtocol: class{
    
    var scrollPosition: ScrollPosition { get set }
    
    
    /// プログラムで変更した場合
    ///
    /// - Parameter direction: <#direction description#>
    func changePageByProgram(_ direction: UIPageViewControllerNavigationDirection)
}



