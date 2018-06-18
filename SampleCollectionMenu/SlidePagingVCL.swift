//
//  SlidePagingVCL.swift
//  SampleCollectionMenu
//
//  Created by 平塚 俊輔 on 2018/05/23.
//  Copyright © 2018年 平塚俊輔. All rights reserved.
//

import UIKit



protocol ScrollActionDelegate: class{
    
    /// 横scrollした後
    /// menuを選択した際はここは通らない。
    ///
    /// - Parameter direction: <#direction description#>
    func afterScroll(_ direction: ScrollDirection)
}

protocol SlidePagingVCLProtocol: class{
    func getVCL() -> UIViewController
    func changePageByProgram(_ direction: UIPageViewControllerNavigationDirection)
    
    func beforeScroll(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    
    func afterScroll(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    
    func goBackPage(viewController: UIViewController) -> UIViewController?
    
    func goFowardPage(viewController: UIViewController) -> UIViewController?
    
    func viewControllerAtIndex(index:Int) -> UIViewController?
}

protocol ChildPageDelegate: class{
    /// 子供のアクションを追加する
    ///
    /// - Parameter searchvcl: <#searchvcl description#>
    func actionChild(_ vcl: UIViewController)
}

extension SlidePagingVCL{
    
    
    func getVCL() -> UIViewController{
        return storyboard!.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
    }
    
    func changePageByProgram(_ direction: UIPageViewControllerNavigationDirection){
        
        // このときはdelegateメソッドは呼ばれない
        
        
        if direction == .forward{
            if let currentvcl = self.viewControllers?.first,let nextvcl = goFowardPage(viewController: currentvcl) as? SampleViewController{
                setViewControllers([nextvcl], direction: .forward, animated: true, completion: nil)
                childDelegate?.actionChild(nextvcl)
            }
        }else{
            if let currentvcl = self.viewControllers?.first,let backvcl = goBackPage(viewController: currentvcl) as? SampleViewController{
                setViewControllers([backvcl], direction: .reverse, animated: true, completion: nil)
                childDelegate?.actionChild(backvcl)
            }
        }
    }
    
}


class SlidePagingVCL: UIPageViewController,SlidePagingVCLProtocol {
    
    
    weak var actionDelegate: ScrollActionDelegate?
    weak var childDelegate: ChildPageDelegate?
    
    var scrollPosition: ScrollPosition = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getVCL()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
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
    
    func beforeScroll(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        if self.scrollPosition == .zero{
            return nil
        }
        
        return goBackPage(viewController: viewController)
    }

    func afterScroll(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        if self.scrollPosition == .limit{
            return nil
        }
        
        return goFowardPage(viewController: viewController)
    }
    
    func goBackPage(viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ChildVCL).pageIndex
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func goFowardPage(viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ChildVCL).pageIndex
        
        if index == NSNotFound {
            return nil;
        }
        index += 1
        
        return self.viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController? {
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SampleViewController") as? SampleViewController{
            vc.pageIndex = index
            return vc
        }
        return nil
    }
    
    

}

extension SlidePagingVCL : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return beforeScroll(pageViewController,viewControllerBefore: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return afterScroll(pageViewController,viewControllerBefore: viewController)
    }
    
    
}

extension SlidePagingVCL: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        if let currentvcl = pageViewController.viewControllers?.first as? ChildVCL
            ,let prevvcl = previousViewControllers.first as? ChildVCL {
            
            if currentvcl.pageIndex > prevvcl.pageIndex{
                actionDelegate?.afterScroll(.left)
            }else if currentvcl.pageIndex < prevvcl.pageIndex{
                actionDelegate?.afterScroll(.right)
            }
            
            childDelegate?.actionChild(currentvcl)
        }
        
    }
}
