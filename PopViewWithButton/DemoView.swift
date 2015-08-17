//
//  ViewController.swift
//  PopViewWithButton
//
//  Created by 史凯迪 on 15/8/12.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var popView: popBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    @IBAction func ShowMenu(sender: UIButton) {
        if let button: popBarViewButton  = sender as? popBarViewButton {
            button.togglePopView(sender.frame)
            button.setDefaultAction({ () -> Void in
                button.togglePopView(sender.frame)
                }, shareAction: { () -> Void in
                    button.togglePopView(sender.frame)
            })
        }
    }
}

