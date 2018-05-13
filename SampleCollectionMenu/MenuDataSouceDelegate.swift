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
    
    func initWorkDay(){
        // 現在日時と最終日を初期化する
        objDay.initCurrentDate()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 90
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    /**
     セル一つ一つの定義
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:DateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let specificDate: Date = objDay.getDateFromDiff(Double(indexPath.row), date: objDay.nowDate)
        let date: String = DateFormatters.monthDateFormatter.string(from: specificDate)
        let weeklane: String = specificDate.weekName
        cell.dateLabel.text = date
        cell.weekLabel.text = weeklane
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
            cell.backgroundColor = UIColor(named: "red")
        }
    }
}
