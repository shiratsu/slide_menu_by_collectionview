//
//  MenuDataSouceDelegate.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class MenuDataSouceDelegate: NSObject,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    var objMenu: DateMenu = DateMenu()
    
    var prevIndexPath: IndexPath? = nil
    
    lazy var intLastSection: Int = 0
    
    lazy var intLastRowCount: Int = 0
    
    func initMenu(){
        
        var objDay: WorkDay = WorkDay()
        
        // 現在日時と最終日を初期化する
        objDay.initCurrentDate()
        
        // メニューデータを作成する
        objMenu.initMenu(90, fromDate: objDay.nowDate)
        
        // 最後のsecion
        intLastSection = objMenu.arySection.count-1
        
        // 最後のsectionのrow
        intLastRowCount = objMenu.aryRows[intLastSection]
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
        cell.initCellCondition()
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
        
        if let cell: DateCell = collectionView.cellForItem(at: indexPath) as? DateCell{
            cell.afterSelectedItem()
            
            if let constIndexPath = prevIndexPath{
                collectionView.reloadItems(at: [constIndexPath])
            }
            // 前の選択cellをセット
            prevIndexPath = indexPath
            
            _scrollToSpecificPath(indexPath, collectionView: collectionView)
            
        }
    }
    
    
    /// 指定ポジションまで移動
    ///
    /// - Parameters:
    ///   - indexPath: <#indexPath description#>
    ///   - collectionView: <#collectionView description#>
    fileprivate func _scrollToSpecificPath(_ indexPath: IndexPath, collectionView: UICollectionView){
        
        var toIndexPath: IndexPath? = nil
        
        if intLastSection != indexPath.section{
            if indexPath.row > 1{
                toIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
                
            }else{
                toIndexPath = indexPath
            }
        }else{
            
            let intDiff: Int = intLastRowCount-indexPath.row
            
            if intDiff < 5{
                toIndexPath = indexPath
            }else{
                toIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
            }
        }
        
        if let constIndexPath = toIndexPath{
            // cellを移動
            collectionView.scrollToItem(at: constIndexPath, at: .centeredHorizontally, animated: true)
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
extension MenuDataSouceDelegate: ScrollActionDelegate{
    
    
    /// scroll後のactionを定義
    ///
    /// - Parameter direction: <#direction description#>
    func afterScroll(_ direction: ScrollDirection) {
        
    }
    
    
}


