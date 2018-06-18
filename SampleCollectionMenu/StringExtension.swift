//
//  StringExtension.swift
//  shotworks_customer
//
//  Created by 平塚 俊輔 on 2018/06/03.
//  Copyright © 2018年 ‚àö√á≈ì√Ñ‚Äö√¢‚Ä¢‚àö√á¬¨‚àû‚àö‚àÇ ‚Äö√Ñ‚àû‚àö‚àè‚àö¬ß‚àö√£¬¨‚à´‚àö√Ü. All rights reserved.
//

import Foundation

extension String{
    
    /// 文字列からdate型を返す
    ///
    /// - Parameter format: <#format description#>
    /// - Returns: <#return value description#>
    func dateFromString(_ format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Date().calendar
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
