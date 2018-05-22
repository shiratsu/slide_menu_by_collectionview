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
    
    
    /// ページングメニュー初期化
    fileprivate func _initCollectionView(){
        
        let nib  = UINib(nibName: "DateCell", bundle:nil)
        let sectionnib  = UINib(nibName: "SectionHeader", bundle:nil)
        menuview.register(nib, forCellWithReuseIdentifier: "DateCell")
        menuview.register(sectionnib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        menuview.collectionViewLayout = collectionViewLayout
        
        menuview.backgroundColor = UIColor.clear
        menuview.allowsMultipleSelection = false
        menuview.allowsSelection = true
        
        menuview.dataSource = objDatasourceDelegate
        menuview.delegate = objDatasourceDelegate
        objDatasourceDelegate.actionDelegate = self
        
        objDatasourceDelegate.initMenu()
        
        menuview.reloadData()

    }
    
    
    /// ページングされる側初期化
    fileprivate func _initPaging(){
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sample1 = storyboard.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
        let sample2 = storyboard.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
        let sample3 = storyboard.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
        
        
        // 1
        sample1.view.backgroundColor = UIColor.red
        sample2.view.backgroundColor = UIColor.blue
        sample3.view.backgroundColor = UIColor.green
        
        sample1.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height)
        sample2.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height)
        sample3.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height)
        
        print(sample1.view.frame)
        
        // 1
//        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
//        view1.backgroundColor = UIColor.red
//
//        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
//        view2.backgroundColor = UIColor.blue
//
//        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: dataview.frame.size.height))
//        view3.backgroundColor = UIColor.green
        
//        print(view1.frame)
        
        // 2
        dataview.numPages = 3
        dataview.viewObjects = [sample1.view, sample2.view, sample3.view]
//         dataview.viewObjects = [view1, view2, view3]
        
        print(sample1.view.parentViewController())
        
        // 3
        dataview.setup()
        
        dataview.actionDelegate = self
        
//        let view1 = dataview.getSubView()
//        let vcl = view1?.parentViewController() as? SampleViewController
//        print(view1)
//        print(view1?.parentViewController())
        
        dataview.getParentViews()
        
        changeSampleCard(IndexPath(row: 0, section: 0))
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

extension ViewController: CollectionMenuProtocol{
    
    
    /// ヘッダのメニューで選択した時に
    /// 最後に、実際のscroll処理が呼ばれる
    ///
    /// - Parameter indexPath: <#indexPath description#>
    func afterSelected(_ indexPath: IndexPath, selectedIndexPath prevIndexPath: IndexPath?) {
        
        // 最後のrow,sectionをセット
        let intLastSection: Int = objDatasourceDelegate.objMenu.arySection.count-1
        
        let intLastIndexRow: Int = objDatasourceDelegate.objMenu.aryRows[intLastSection]
        
        guard let constIndexPath: IndexPath = prevIndexPath else{
            _callScrollMethod(x: dataview.contentOffset.x+view.frame.width)
            return
        }
        
        // 前のが小さい
        if indexPath.section > constIndexPath.section{
            _callScrollMethod(x: dataview.contentOffset.x+view.frame.width)
            
        // 前のが大きい
        }else if indexPath.section < constIndexPath.section{
            _callScrollMethod(x: dataview.contentOffset.x-view.frame.width)
        // 同じ
        }else{
            // １番前
            if indexPath.row == 0 && indexPath.section == 0{
                if indexPath.row <= constIndexPath.row{
                    dataview.currentScrollPosition = .zero
                    _callScrollMethod(x: 0)
                }
            // 一番後ろ
            }else if indexPath.row == intLastIndexRow && indexPath.section == intLastSection{
                if indexPath.row >= constIndexPath.row{
                    dataview.currentScrollPosition = .limit
                    _callScrollMethod(x: view.frame.width*4)
                }
                
            }else{
                // 前のが大きい
                if indexPath.row < constIndexPath.row{
                    dataview.setContentOffset(CGPoint(x: dataview.contentOffset.x-view.frame.width, y: 0), animated: true)
                    _callScrollMethod(x: dataview.contentOffset.x-view.frame.width)
                    
                // 前のが小さい
                }else if indexPath.row > constIndexPath.row{
                    _callScrollMethod(x: dataview.contentOffset.x+view.frame.width)
                }
            }
        }
    }
    
    
    /// scrollのメソッドをコール
    /// collectionviewの選択後にcallされる。横スライド分だけなので、yは0
    ///
    /// - Parameter x: <#x description#>
    fileprivate func _callScrollMethod(x: CGFloat){
        dataview.isCanCallAfter = false
        dataview.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        dataview.scrollViewDidEndDecelerating(dataview)
    }
}

extension ViewController: ScrollActionDelegate{
    
    
    /// 横scrollした後
    /// menuを選択した際はここは通らない。
    ///
    /// - Parameter direction: <#direction description#>
    func afterScroll(_ direction: ScrollDirection) {
        
        if let currentSelectPaths: [IndexPath] = menuview.indexPathsForSelectedItems,currentSelectPaths.count > 0{
            
            let currentSelectPath: IndexPath = currentSelectPaths[0]
            let visibleIndexPaths: [IndexPath] = menuview.indexPathsForVisibleItems
            
            switch direction{
            
            /// 前に進む
            case .left:
                
                if let nextSelectPath: IndexPath = _getNextPath(currentSelectPath
                    , intSectionCount: objDatasourceDelegate.objMenu.arySection.count
                    , aryRow: objDatasourceDelegate.objMenu.aryRows){
                    
                    // 画面外に選択のセルがでていた場合、まずは選択してたセルまで戻る
                    // そうしないと選択できない。
                    if visibleIndexPaths.index(of: nextSelectPath) == nil{
                        menuview.scrollToItem(at: nextSelectPath, at: .centeredHorizontally, animated: true)
                    }
                    
                    menuview.selectItem(at: nextSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objDatasourceDelegate.isScroll = false
                    objDatasourceDelegate.collectionView(menuview, didSelectItemAt: nextSelectPath)
                    
                    // 一番後ろに来てしまった場合、scrollできないように、調整
                    if nextSelectPath.row == objDatasourceDelegate.intLastRowCount-1 && nextSelectPath.section == objDatasourceDelegate.intLastSection{
                        dataview.currentScrollPosition = .limit
                    }
                    changeSampleCard(nextSelectPath)
                }
                
                break
                
                
            /// 後ろに下がる
            case .right:
                
                if let prevSelectPath: IndexPath = _getPrevPath(currentSelectPath
                    , intSectionCount: objDatasourceDelegate.objMenu.arySection.count
                    , aryRow: objDatasourceDelegate.objMenu.aryRows){
                    
                    print(prevSelectPath)
                    
                    // 画面外に選択のセルがでていた場合、まずは選択してたセルまで戻る
                    // そうしないと選択できない。
                    if visibleIndexPaths.index(of: prevSelectPath) == nil{
                        menuview.scrollToItem(at: prevSelectPath, at: .centeredHorizontally, animated: true)
                    }
                    
                    menuview.selectItem(at: prevSelectPath, animated: false, scrollPosition: .init(rawValue: 0))
                    objDatasourceDelegate.isScroll = false
                    objDatasourceDelegate.collectionView(menuview, didSelectItemAt: prevSelectPath)
                    
                    // １番前に来ていた場合、scrollできないように調整
                    if prevSelectPath.row == 0 && prevSelectPath.section == 0{
                        dataview.currentScrollPosition = .zero
                    }
                    changeSampleCard(prevSelectPath)
                }
                
                break
            case .default:
                break
            }
            
        }else{
            switch direction{
                
            /// 前に進む
            case .left:
                menuview.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objDatasourceDelegate.collectionView(menuview, didSelectItemAt: IndexPath(row: 1, section: 0))
                
                changeSampleCard(IndexPath(row: 1, section: 0))
                break
            
            /// 後ろに下がる
            case .right:
                menuview.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
                objDatasourceDelegate.collectionView(menuview, didSelectItemAt: IndexPath(row: 0, section: 0))
                changeSampleCard(IndexPath(row: 0, section: 0))
                // １番前に来ていた場合、scrollできないように調整
                dataview.currentScrollPosition = .zero
                
                break
            case .default:
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
    
    func changeSampleCard(_ indexPath: IndexPath){
        
        dataview.getParentViews()
        
        let view1 = dataview.getSubView()
        let vcl = view1?.parentViewController() as? SampleViewController
//        print(view1)
//        print(view1?.parentViewController())
//        print(vcl)
        if let view = dataview.getSubView(),let vcl = view.parentViewController() as? SampleViewController{
            
            let startDate = objDatasourceDelegate.objMenu.aryStartDate[indexPath.section]
            
            let targetDate: Date = startDate.getDateFromDiff(Double(indexPath.row))
            
            let date: String = DateFormatters.monthDateFormatter.string(from: targetDate)
            
            vcl.dateLabel.text = date
        }
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}
