//
//  DateExtension.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import Foundation

extension TimeZone {
    
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    static let japan = Locale(identifier: "ja_JP")
}

extension Date {
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale   = .japan
        return calendar
    }
    
    var weekName: String {
        let index = calendar.component(.weekday, from: self) - 1 // index値を 1〜7 から 0〜6 にしている
        return ["日", "月", "火", "水", "木", "金", "土"][index]
    }
    
}
