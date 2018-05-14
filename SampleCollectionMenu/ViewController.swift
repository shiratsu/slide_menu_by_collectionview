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
    @IBOutlet weak var dataview: UIScrollView!
    
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
    
    var objDatasourceDelegate: MenuDataSouceDelegate = MenuDataSouceDelegate()
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

