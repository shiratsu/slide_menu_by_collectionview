//
//  SlideMenuAction.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/06/18.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class SlideMenuAction: NSObject {
    
    
    
    /// 選択状態で遷移してきたときの初期設定
    ///
    /// - Parameters:
    ///   - targetDate: <#targetDate description#>
    ///   - aryStartDate: <#aryStartDate description#>
    ///   - menuview: <#menuview description#>
    ///   - objMenuDelegate: <#objMenuDelegate description#>
    ///   - aryRows: <#aryRows description#>
    func initialMenu(_ targetDate: Date?
        , aryStartDate: [Date]
        , menuview: UICollectionView
        , objMenuDelegate: HeaderMenuProtocol
        , aryRows: [Int]
        ) -> Int{
        if let constTargetDate = targetDate{
            // 最初の日時を取得
            let startDate: Date = aryStartDate[0]
            
            guard let fixStartDate: Date = startDate.getBaseDate() else{
                return 0
            }
            
            // 月の差分を取得
            var intMonthDiff: Int = startDate.monthsDiff(constTargetDate)
            let intRealDateDiff: Int = fixStartDate.daysDiff(constTargetDate)
            
            // sectionの日付を取得
            let sectionStartDate: Date = aryStartDate[intMonthDiff]
            
            guard let fixSectionStartDate: Date = sectionStartDate.getBaseDate() else{
                return 0
            }
            
            // 日付の差分を取得
            var intDateDiff: Int = fixSectionStartDate.daysDiff(constTargetDate)
            
            let rowCount = aryRows[intMonthDiff]
            
            // 次のsection
            if rowCount < intDateDiff{
                intMonthDiff += 1
                intDateDiff = 0
            }
            
            let selectedIndexPath: IndexPath = IndexPath(row: intDateDiff, section: intMonthDiff)
            
            if !menuview.validate(indexPath: selectedIndexPath){
                return 0
            }
            
            objMenuDelegate.selectedIndexPath = selectedIndexPath
            
            // 自分でcellを選択する必要あり
            // https://stackoverflow.com/questions/15330844/uicollectionview-select-and-deselect-issue
            guard let cell = menuview.dequeueReusableCell(withReuseIdentifier: "DateCell", for: selectedIndexPath) as? DateCell else{
                return 0
            }
            cell.isSelected = true
            cell.isSelect = true
            menuview.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            
            return intRealDateDiff
        }
        
        return 0
    }
    
    /// scroll後のアクション
    ///
    /// - Parameters:
    ///   - direction: <#direction description#>
    ///   - collectionView: <#collectionView description#>
    ///   - objMenuDelegate: <#objMenuDelegate description#>
    ///   - pagevcl: <#pagevcl description#>
    ///   - arySection: <#arySection description#>
    ///   - aryRows: <#aryRows description#>
    func afterScroll(_ direction: ScrollDirection
        , collectionView: UICollectionView
        , objMenuDelegate: HeaderMenuProtocol
        , pagevcl: SlidePagingProtocol
        , arySection: [String]
        , aryRows: [Int]
        ){
        if let currentSelectPaths: [IndexPath] = collectionView.indexPathsForSelectedItems,currentSelectPaths.count > 0{
            
            let currentSelectPath: IndexPath = currentSelectPaths[0]
            let visibleIndexPaths: [IndexPath] = collectionView.indexPathsForVisibleItems
            
            switch direction{
                
            /// 前に進む
            case .left:
                
                if let nextSelectPath: IndexPath = _getNextPath(currentSelectPath
                    , intSectionCount: arySection.count
                    , aryRow: aryRows){
                    
                    // 画面外に選択のセルがでていた場合、まずは選択してたセルまで戻る
                    // そうしないと選択できない。
                    if visibleIndexPaths.index(of: nextSelectPath) == nil{
                        collectionView.scrollToItem(at: nextSelectPath, at: .centeredHorizontally, animated: true)
                    }
                    objMenuDelegate.isScroll = false
                    collectionView.selectItem(at: nextSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objMenuDelegate.collectionView?(collectionView, didSelectItemAt: nextSelectPath)
                    
                    // 一番後ろに来てしまった場合、scrollできないように、調整
                    if nextSelectPath.row == objMenuDelegate.intLastRowCount-1 && nextSelectPath.section == objMenuDelegate.intLastSection{
                        pagevcl.scrollPosition = .limit
                    }else{
                        pagevcl.scrollPosition = .default
                    }
                    
                }
                
                break
                
                
            /// 後ろに下がる
            case .right:
                
                if let prevSelectPath: IndexPath = _getPrevPath(currentSelectPath
                    , intSectionCount: arySection.count
                    , aryRow: aryRows){
                    
                    
                    // 画面外に選択のセルがでていた場合、まずは選択してたセルまで戻る
                    // そうしないと選択できない。
                    if visibleIndexPaths.index(of: prevSelectPath) == nil{
                        collectionView.scrollToItem(at: prevSelectPath, at: .centeredHorizontally, animated: true)
                    }
                    objMenuDelegate.isScroll = false
                    
                    collectionView.selectItem(at: prevSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objMenuDelegate.collectionView?(collectionView, didSelectItemAt: prevSelectPath)
                    
                    // １番前に来ていた場合、scrollできないように調整
                    if prevSelectPath.row == 0 && prevSelectPath.section == 0{
                        pagevcl.scrollPosition = .zero
                    }else{
                        pagevcl.scrollPosition = .default
                    }
                }
                
                break
            case .default:
                break
            }
            
        }else{
            switch direction{
                
            /// 前に進む
            case .left:
                objMenuDelegate.isScroll = false
                collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objMenuDelegate.collectionView?(collectionView, didSelectItemAt: IndexPath(row: 1, section: 0))
                pagevcl.scrollPosition = .default
                break
                
            /// 後ろに下がる
            case .right:
                objMenuDelegate.isScroll = false
                collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objMenuDelegate.collectionView?(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                
                // １番前に来ていた場合、scrollできないように調整
                pagevcl.scrollPosition = .zero
                
                break
            case .default:
                break
            }
        }
    }
    
    func afterDeselect(dic_search: NSMutableDictionary) -> NSMutableDictionary{
        
        
        return NSMutableDictionary(dictionary: [:])
    }
    
    /// collectionviewのメニューを選択した
    ///
    /// - Parameters:
    ///   - indexPath: <#indexPath description#>
    ///   - prevIndexPath: <#prevIndexPath description#>
    ///   - arySection: <#arySection description#>
    ///   - aryRows: <#aryRows description#>
    ///   - pagevcl: <#pagevcl description#>
    func afterSelected(_ indexPath: IndexPath, prevIndexPath: IndexPath?, arySection: [String], aryRows: [Int], pagevcl: SlidePagingProtocol){
        
        // 最後のrow,sectionをセット
        let intLastSection: Int = arySection.count-1
        
        let intLastIndexRow: Int = aryRows[intLastSection]
        
        guard let constIndexPath: IndexPath = prevIndexPath else{
            pagevcl.changePageByProgram(.forward)
            return
        }
        
        // 前のが小さい
        if indexPath.section > constIndexPath.section{
            pagevcl.changePageByProgram(.forward)
            
            // 前のが大きい
        }else if indexPath.section < constIndexPath.section{
            pagevcl.changePageByProgram(.reverse)
            // 同じ
        }else{
            // １番前
            if indexPath.row == 0 && indexPath.section == 0{
                if indexPath.row <= constIndexPath.row{
                    pagevcl.changePageByProgram(.reverse)
                    pagevcl.scrollPosition = .zero
                    
                }
                // 一番後ろ
            }else if indexPath.row == intLastIndexRow && indexPath.section == intLastSection{
                if indexPath.row >= constIndexPath.row{
                    pagevcl.changePageByProgram(.forward)
                    pagevcl.scrollPosition = .limit
                }
                
            }else{
                // 前のが大きい
                if indexPath.row < constIndexPath.row{
                    pagevcl.changePageByProgram(.reverse)
                    // 前のが小さい
                }else if indexPath.row > constIndexPath.row{
                    pagevcl.changePageByProgram(.forward)
                    
                }
            }
        }
    }
    
    /// 次のselectすべきものを取得
    ///
    /// - Parameters:
    ///   - currentSelectPaths: <#currentSelectPaths description#>
    ///   - intSectionCount: <#intSectionCount description#>
    ///   - intRowCount: <#aryRow description#>
    ///   - return IndexPath?
    fileprivate func _getNextPath(_ currentSelectPath: IndexPath
        , intSectionCount: Int
        , aryRow: [Int]) -> IndexPath?{
        
        var toIndexPath: IndexPath?
        
        // １番最後のrowを取得
        let intRowCount: Int = aryRow[currentSelectPath.section]
        
        // １番後ろのsectionじゃない場合
        if currentSelectPath.section != intSectionCount-1{
            
            // sectionの中の１番後ろじゃない場合
            if currentSelectPath.row != intRowCount-1{
                
                toIndexPath = IndexPath(row: currentSelectPath.row+1, section: currentSelectPath.section)
            }else{
                toIndexPath = IndexPath(row: 0, section: currentSelectPath.section+1)
            }
            
        }else{
            // sectionの中の１番後ろじゃない場合
            if currentSelectPath.row != intRowCount-1{
                toIndexPath = IndexPath(row: currentSelectPath.row+1, section: currentSelectPath.section)
                
            }else{
                toIndexPath = IndexPath(row: intRowCount-1, section: currentSelectPath.section)
            }
        }
        
        return toIndexPath
    }
    
    /// 前のselectすべきものを取得
    ///
    /// - Parameters:
    ///   - currentSelectPath: <#currentSelectPaths description#>
    ///   - intSectionCount: <#intSectionCount description#>
    ///   - intRowCount: <#aryRow description#>
    ///   - return IndexPath?
    fileprivate func _getPrevPath(_ currentSelectPath: IndexPath
        , intSectionCount: Int
        , aryRow: [Int]) -> IndexPath?{
        
        var toIndexPath: IndexPath?
        
        // １番前のsectionじゃない場合
        if currentSelectPath.section != 0{
            
            // sectionの中の１番前じゃない場合
            if currentSelectPath.row != 0{
                
                toIndexPath = IndexPath(row: currentSelectPath.row-1, section: currentSelectPath.section)
            }else{
                // 前のsectionの一番後ろのrowに戻る
                let prevLastRow: Int = aryRow[currentSelectPath.section-1]
                
                toIndexPath = IndexPath(row: prevLastRow-1, section: currentSelectPath.section-1)
            }
            
        }else{
            // sectionの中の１番前じゃない場合
            if currentSelectPath.row != 0{
                toIndexPath = IndexPath(row: currentSelectPath.row-1, section: currentSelectPath.section)
            }else{
                toIndexPath = IndexPath(row: 0, section: currentSelectPath.section)
            }
        }
        
        return toIndexPath
    }
}

