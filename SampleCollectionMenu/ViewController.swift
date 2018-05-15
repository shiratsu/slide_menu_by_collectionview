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
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: dataview.frame.size.width, height: dataview.frame.size.height))
        view1.backgroundColor = UIColor.red
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: dataview.frame.size.width, height: dataview.frame.size.height))
        view2.backgroundColor = UIColor.blue
        
        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: dataview.frame.size.width, height: dataview.frame.size.height))
        view3.backgroundColor = UIColor.green
        
        // 2
        dataview.numPages = 3
        dataview.viewObjects = [view1, view2, view3]
        
        // 3
        dataview.setup()
        
        dataview.delegate = objDatasourceDelegate
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

