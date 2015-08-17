//
//  popView.swift
//  PopBarButtonDemo
//
//  Created by 史凯迪 on 15/8/17.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

class popView: UIView {
    @IBAction func GreatAction(sender: AnyObject) {
        print("点赞")
        _autoClosePopBarView()
    }
    @IBAction func DeleteAction(sender: AnyObject) {
        print("删除")
        _autoClosePopBarView()
    }
    @IBAction func ShareAction(sender: AnyObject) {
        print("分享")
        _autoClosePopBarView()
    }
}