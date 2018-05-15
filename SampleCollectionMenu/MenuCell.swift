//
//  MenuCell.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/05/15.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

protocol MenuCellProtocol : class{
    
    
    /// selectした後に何かするのに使う
    func afterSelectedItem()
    
    /// 初期のcellの状態
    func initCellCondition()
}

extension UICollectionViewCell {
    
    func getIndexPath(_ collectionView: UICollectionView) -> IndexPath? {
        return collectionView.indexPath(for: self)
    }
}
