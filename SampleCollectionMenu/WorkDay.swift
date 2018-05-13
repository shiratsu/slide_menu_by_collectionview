//
//  WorkDay.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class WorkDay: NSObject {
    
    let aryTmpDay: [String?] = [String?](repeating: nil, count:90)
    
    var nowDate: Date!
    
    /// 現在日を初期化する
    func initCurrentDate(){
        nowDate = Date()
    }
    
    /// 指定差分日付を取得
    ///
    /// - Parameters:
    ///   - doubleDiff: <#doubleDiff description#>
    /// - Returns: <#return value description#>
    func getDateFromDiff(_ doubleDiff: Double,date: Date) -> Date{
        
        let tmpDate: Date = Date(timeInterval: 86400*doubleDiff, since: date)
        return tmpDate
    }
}
