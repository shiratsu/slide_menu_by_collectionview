//
//  SampleViewController.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/05/22.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    var pageIndex: Int = 0
    /**
     xibを読み込む
     */
    override func loadView() {
        if let view = UINib(nibName: "SampleViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
