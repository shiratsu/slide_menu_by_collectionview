//
//  CollectionExtension.swift
//  shotworks_customer
//
//  Created by 平塚 俊輔 on 2018/06/20.
//  Copyright © 2018年 ‚àö√á≈ì√Ñ‚Äö√¢‚Ä¢‚àö√á¬¨‚àû‚àö‚àÇ ‚Äö√Ñ‚àû‚àö‚àè‚àö¬ß‚àö√£¬¨‚à´‚àö√Ü. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Int) -> Iterator.Element? {
        
        if let intIndex = index as? Index{
            return (self.count > index) ? self[intIndex] : nil
        }else{
            return nil
        }
    }
}
