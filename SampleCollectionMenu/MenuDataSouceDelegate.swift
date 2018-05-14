//
//  MenuDataSouceDelegate.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class MenuDataSouceDelegate: NSObject,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var objDay: WorkDay = WorkDay()
    var objMenu: DateMenu = DateMenu()
    
    func initMenu(){
        // 現在日時と最終日を初期化する
        objDay.initCurrentDate()
        
        // メニューデータを作成する
        objMenu.initMenu(90, fromDate: objDay.nowDate)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objMenu.aryRows[section]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return objMenu.arySection.count
    }
    
    /**
     セル一つ一つの定義
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:DateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        // 最初の日時を取得
        let startDate: Date = objMenu.aryStartDate[indexPath.section]
        let targetDate: Date = startDate.getDateFromDiff(Double(indexPath.row))
        
        let date: String = DateFormatters.monthDateFormatter.string(from: targetDate)
        let weekname: String = targetDate.weekName
        cell.dateLabel.text = date
        cell.weekLabel.text = weekname
        return cell
    }
    
    /**
     セルのサイズ決定
     
     - parameter collectionView:       <#collectionView description#>
     - parameter collectionViewLayout: <#collectionViewLayout description#>
     - parameter indexPath:            <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 55)
        
    }
    
    /**
     セルを選択時
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.backgroundColor = UIColor(named: "orange")
        }
    }
    
    
    /// sectionのヘッダ
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - kind: <#kind description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader else {
            fatalError("Could not find proper header")
        }
        
        if kind == UICollectionElementKindSectionHeader {
            header.sectionLabel.text = objMenu.arySection[indexPath.section]+"月"
            return header
        }
        
        return UICollectionReusableView()
    }
}
