//
//  MenuDataSouceDelegate.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

protocol CollectionMenuProtocol: class{
    
    
    /// 選択終わったら
    ///
    /// - Parameter indexPath: <#indexPath description#>
    /// - Parameter selectedIndexPath: <#indexPath description#>
    func afterSelected(_ indexPath: IndexPath, selectedIndexPath: IndexPath?)
}

class MenuDataSouceDelegate: NSObject,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    var objMenu: DateMenu = DateMenu()
    
    var selectedIndexPath: IndexPath? = nil
    
    var intLastSection: Int = 0
    
    var intLastRowCount: Int = 0
    
    weak var actionDelegate: CollectionMenuProtocol?
    
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
        
        if let constSelectedItemPath = selectedIndexPath,indexPath == constSelectedItemPath{

            cell.isSelect = true

        }else{
            cell.isSelect = false
            
        }
                
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
        
        actionDelegate?.afterSelected(indexPath, selectedIndexPath: selectedIndexPath)
        
        guard let cell: DateCell = collectionView.cellForItem(at: indexPath) as? DateCell else{
            return
        }

        
        if let constSelectedItemPath = selectedIndexPath,let pcell: DateCell = collectionView.cellForItem(at: constSelectedItemPath) as? DateCell{
            
            if indexPath == constSelectedItemPath{
                selectedIndexPath = nil
                cell.isSelect = false
            }else{
                // 前の選択cellをセット
                selectedIndexPath = indexPath
                pcell.isSelect = false
                cell.isSelect = true
            }
            
        }else{
            // 前の選択cellをセット
            selectedIndexPath = indexPath
            cell.isSelect = true
        }
        
        
        _scrollToSpecificPath(indexPath, collectionView: collectionView)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let cell: DateCell = collectionView.cellForItem(at: indexPath) as? DateCell else{
//            return
//        }
//        cell.isSelected = false
//
//        selectedIndexPath = nil
//    }
    
    /// 指定ポジションまで移動
    ///
    /// - Parameters:
    ///   - indexPath: <#indexPath description#>
    ///   - collectionView: <#collectionView description#>
    fileprivate func _scrollToSpecificPath(_ indexPath: IndexPath, collectionView: UICollectionView){
        
        var toIndexPath: IndexPath? = nil
        
        if intLastSection != indexPath.section{
            if indexPath.row > 1{
                
                // 多分ここでバグが出てる
                // indexPath.rowがラストを越えたら、次のsectionにする
                let tmpRowCount: Int = objMenu.aryRows[indexPath.section]
                if indexPath.row < tmpRowCount-1{
                    toIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
                }else{
                    toIndexPath = indexPath
                }
                
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
            print("test")
            print(constIndexPath)
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



