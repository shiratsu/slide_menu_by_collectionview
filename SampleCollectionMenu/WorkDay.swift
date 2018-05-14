//
//  WorkDay.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

struct WorkDay {
    
    let aryTmpDay: [String?] = [String?](repeating: nil, count:90)
    
    var nowDate: Date!
    
    /// 現在日を初期化する
    mutating func initCurrentDate(){
        nowDate = Date()
    }
    
    
}
