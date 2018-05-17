//
//  DateCell.swift
//  SampleCollectionMenu
//
//  Created by 平塚俊輔 on 2018/05/13.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    var isSelect: Bool = false{
        didSet{
            setConditionBySelected(isSelect)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initCellCondition()
        isSelect = false
    }
    
}

extension DateCell: MenuCellProtocol{
    
    
    /// <#Description#>
    ///
    /// - Parameter isSelect: <#isSelect description#>
    func setConditionBySelected(_ isSelect: Bool){
        if isSelect == true{
            afterSelectedItem()
        }else{
            initCellCondition()
        }
    }
    
    /// 選択した後に呼ばれる
    func afterSelectedItem() {
        dataView.backgroundColor = UIColor.orange
        
    }
    
    func initCellCondition() {
        dataView.backgroundColor = UIColor.white
    }
}
