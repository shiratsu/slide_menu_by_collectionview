//
//  File.swift
//  shotworks_customer
//
//  Created by 平塚 俊輔 on 2018/06/03.
//  Copyright © 2018年 ‚àö√á≈ì√Ñ‚Äö√¢‚Ä¢‚àö√á¬¨‚àû‚àö‚àÇ ‚Äö√Ñ‚àû‚àö‚àè‚àö¬ß‚àö√£¬¨‚à´‚àö√Ü. All rights reserved.
//

import UIKit

protocol HeaderMenuProtocol: UICollectionViewDelegate,UICollectionViewDataSource{
    
    var intLastSection: Int { get set }
    
    var intLastRowCount: Int { get set }
    
    var isScroll: Bool { get set }
    
    var selectedIndexPath: IndexPath? { get set }
}
