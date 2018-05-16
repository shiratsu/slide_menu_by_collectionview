//
//  ViewController.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var menuview: UICollectionView!
    @IBOutlet weak var dataview: InfiniteScrollView!
    
    fileprivate lazy var screenWidth : CGFloat = UIScreen.main.bounds.width
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset  = UIEdgeInsetsMake(16, 16, 32, 16)
        layout.minimumLineSpacing = 15
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width:50,height:55)
        
        layout.scrollDirection = .horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:50, height:55)
        
        return layout
    }()
    
    fileprivate lazy var objDatasourceDelegate: MenuDataSouceDelegate = MenuDataSouceDelegate()
    
    /**
     xibを読み込む
     */
    override func loadView() {
        if let view = UINib(nibName: "ViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _initCollectionView()
        
        
    }
    
    fileprivate func _initCollectionView(){
        
        let nib  = UINib(nibName: "DateCell", bundle:nil)
        let sectionnib  = UINib(nibName: "SectionHeader", bundle:nil)
        menuview.register(nib, forCellWithReuseIdentifier: "DateCell")
        menuview.register(sectionnib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        menuview.collectionViewLayout = collectionViewLayout
        
        menuview.backgroundColor = UIColor.clear
        
        menuview.dataSource = objDatasourceDelegate
        menuview.delegate = objDatasourceDelegate
        
        objDatasourceDelegate.initMenu()
        
        menuview.reloadData()

    }
    
    fileprivate func _initPaging(){
        
        // 1
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
        view1.backgroundColor = UIColor.red
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
        view2.backgroundColor = UIColor.blue
        
        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
        view3.backgroundColor = UIColor.green
        
        // 2
        dataview.numPages = 3
        dataview.viewObjects = [view1, view2, view3]
        
        // 3
        dataview.setup()
        
        dataview.actionDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _initPaging()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ScrollActionDelegate{
    
    
    /// scrollした後
    ///
    /// - Parameter direction: <#direction description#>
    func afterScroll(_ direction: ScrollDirection) {
        
        print(menuview.indexPathsForSelectedItems)
        
        if let currentSelectPaths: [IndexPath] = menuview.indexPathsForSelectedItems,currentSelectPaths.count > 0{
            
            let currentSelectPath: IndexPath = currentSelectPaths[0]
            
            switch direction{
            case .left:
                
                if let nextSelectPath: IndexPath = _getNextPath(currentSelectPath
                    , intSectionCount: objDatasourceDelegate.objMenu.arySection.count
                    , aryRow: objDatasourceDelegate.objMenu.aryRows){
                    menuview.selectItem(at: nextSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objDatasourceDelegate.collectionView(menuview, didSelectItemAt: nextSelectPath)
                }
                
                break
            case .right:
                
                if let prevSelectPath: IndexPath = _getPrevPath(currentSelectPath
                    , intSectionCount: objDatasourceDelegate.objMenu.arySection.count
                    , aryRow: objDatasourceDelegate.objMenu.aryRows){
                    menuview.selectItem(at: prevSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objDatasourceDelegate.collectionView(menuview, didSelectItemAt: prevSelectPath)
                }
                
                break
            default:
                break
            }
            
        }else{
            switch direction{
            case .left:
                menuview.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objDatasourceDelegate.collectionView(menuview, didSelectItemAt: IndexPath(row: 1, section: 0))
                break
            case .right:
                menuview.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objDatasourceDelegate.collectionView(menuview, didSelectItemAt: IndexPath(row: 0, section: 0))
                
                break
            default:
                menuview.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objDatasourceDelegate.collectionView(menuview, didSelectItemAt: IndexPath(row: 0, section: 0))
                break
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
            
            // sectionの中の１番後ろじゃない場合
            if currentSelectPath.row != 0{
                
                toIndexPath = IndexPath(row: currentSelectPath.row-1, section: currentSelectPath.section)
            }else{
                // 前のsectionの一番後ろのrowに戻る
                let prevLastRow: Int = aryRow[currentSelectPath.section-1]
                
                toIndexPath = IndexPath(row: prevLastRow, section: currentSelectPath.section-1)
            }
            
        }else{
            // sectionの中の１番後ろじゃない場合
            if currentSelectPath.row != 0{
                toIndexPath = IndexPath(row: currentSelectPath.row-1, section: currentSelectPath.section)
            }
        }
        
        return toIndexPath
    }
}
