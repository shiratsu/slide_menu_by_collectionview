//
//  DateMenu.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/05/14.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import Foundation

protocol CollectionMenu: class{
    
}

class DateMenu: CollectionMenu{
    
    
    /// <#Description#>
    var arySection: [String] = []
    var aryRows: [Int] = []
    var aryStartDate: [Date] = []
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - doubleDiff: <#doubleDiff description#>
    ///   - fromDate: <#fromDate description#>
    func initMenu(_ doubleDiff: Double, fromDate: Date){
        
        
        // まずは、最後の日付を取得
        let lastDate: Date = fromDate.getDateFromDiff(doubleDiff)
        
        // 月の差分を取得(これがsectionの数)
        let intDiffMonth: Int = fromDate.monthsDiff(lastDate)+1

        var i: Int = 0
        
        var keepLastDate: Date? = nil
        
        while (i <= intDiffMonth){
            
            
            // 現在月
            if i == 0{
                
                let tmpFromDate: Date = fromDate.getDateFromDiff(Double(-1))
                let tmpLastDate: Date = fromDate.endOfMonth
                _setMontMenu(tmpFromDate, firstDate: fromDate,  lastDate: tmpLastDate, index:i)
                keepLastDate = tmpLastDate
                
            }else if i == intDiffMonth{
                
                let tmpFirstDate: Date = lastDate.startOfMonth()
                if let constLastDate = keepLastDate{
                    _setMontMenu(constLastDate, firstDate: tmpFirstDate,  lastDate: lastDate, index:i)
                }
                
            }else{
                
                if let constLastDate = keepLastDate,let targetMonthDate: Date = fromDate.getMonthFromDiff(i){
                    let tmpLastDate: Date = targetMonthDate.endOfMonth
                    let tmpFirstDate: Date = targetMonthDate.startOfMonth()
                    _setMontMenu(constLastDate, firstDate:tmpFirstDate,  lastDate: tmpLastDate, index:i)
                    keepLastDate = tmpLastDate
                }
                
                
            }
            
            i += 1
        }
    }
    
    
    /// 日付の差分を取得してdicMenuにセット
    ///
    /// - Parameters:
    ///   - startDate: <#startDate description#>
    ///   - latDate: <#latDate description#>
    fileprivate func _setMontMenu(_ startDate: Date, firstDate:Date, lastDate: Date, index: Int) {
        let diffInt: Int = startDate.daysDiff(lastDate)
        let strMonth: String = DateFormatters.monthFormatter.string(from: lastDate)
        
        aryRows.append(diffInt)
        arySection.append(strMonth)
        aryStartDate.append(firstDate)
    }
    
}
