//
//  MenuCell.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/05/15.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import Foundation

protocol MenuCellProtocol : class{
    
    
    /// selectした後に何かするのに使う
    func afterSelectedItem()
}
