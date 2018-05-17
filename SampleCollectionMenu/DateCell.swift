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
    
    override var isSelected: Bool{
        willSet{
            if newValue == true{
                afterSelectedItem()
            }else{
                initCellCondition()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initCellCondition()
        isSelected = false
    }
    
}

extension DateCell: MenuCellProtocol{
    
    
    /// 選択した後に呼ばれる
    func afterSelectedItem() {
        dataView.backgroundColor = UIColor.orange
        
    }
    
    func initCellCondition() {
        dataView.backgroundColor = UIColor.white
    }
}
