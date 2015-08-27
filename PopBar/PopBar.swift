//
//  PopBarView.swift
//
//  Created by 史凯迪 on 15/8/14.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

/* 用于外部关闭最后一个打开的 */
var _lastPopBarView: PopBar?
/* 自动关闭弹出条菜单 */
func _autoClosePopBarView() {
    _lastPopBarView?.togglePopBar(nil)
}

/* 弹出的方向 */
enum PopToDirection: Int {
    case popToLeft = 1;
    case popToRight = 2;
}

/* 弹出的大小设定, 更具需要修改 */
struct PopBarOptions {
    static var popbarNibName: String = ""
    static var popBarWidth: CGFloat = 198
    static var popBarHeight: CGFloat = 30
    static var popbarDistance: CGFloat = 1
    static var popBarBGColor: UIColor =
        UIColor(red: 76/255, green: 81/255, blue: 84/255, alpha: 1)
    static var popToDirection: PopToDirection = .popToLeft
}

class PopBar: UIView {
    
    /* 监测 */
    private var popBarViewHasShow: Bool = false
    private var initCalculate: Bool = false
    
    /* 参数 */
    var nibView: UIView?
    private var collapseFrame: CGRect?      //缩小
    private var expansionFrame: CGRect?     //展开
    
    /* 默认初始化(默认传入展开后的frame) */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        /* 纪录相关的frame */
        self.expansionFrame = frame
        self.collapseFrame =
            CGRect(x: frame.origin.x, y: frame.origin.y,
                width: 0, height: frame.height)
        /* 默认未展开, X/Y均为0 */
        self.frame = self.collapseFrame!
        self.backgroundColor = PopBarOptions.popBarBGColor
        self.initView()
        /* 默认隐藏 */
        self.hidden = true
    }
    
    private func initView() {
        if PopBarOptions.popbarNibName.isEmpty {
            return
        } else {
            let nib: UINib =
                UINib(nibName: PopBarOptions.popbarNibName, bundle: nil)
            self.nibView =
                nib.instantiateWithOwner(self, options: nil)[0] as? UIView
            self.nibView?.frame = CGRectMake(0, 0,
                PopBarOptions.popBarWidth, PopBarOptions.popBarHeight)
            self.nibView?.hidden = true
            self.addSubview(self.nibView!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initCalculateRelativePosition(actionFrame: CGRect) {
            
            var pointY: CGFloat = 0
            var pointXOfCollapse: CGFloat = 0
            var pointXOfExpansion: CGFloat = 0
            
            /* 计算Y */
            let originalY: CGFloat = actionFrame.origin.y
            if actionFrame.height > self.frame.height {
                /* 居中下移 */
                pointY =
                    originalY + ((actionFrame.height - self.frame.height) / 2)
            } else {
                /* 居中上移 */
                pointY =
                    originalY - ((self.frame.height - actionFrame.height) / 2)
            }
            /* 计算X */
            let originalX: CGFloat = actionFrame.origin.x
            switch PopBarOptions.popToDirection {
            case .popToLeft:/* 向左展开 */
                pointXOfCollapse = originalX - PopBarOptions.popbarDistance
                pointXOfExpansion = originalX -
                    (self.expansionFrame!.width + PopBarOptions.popbarDistance)
            case .popToRight:/* 向右展开 */
                pointXOfCollapse = originalX + PopBarOptions.popbarDistance
                pointXOfExpansion = originalX +
                    (self.expansionFrame!.width + PopBarOptions.popbarDistance)
            }
            
            /* 将计算机的结果重新赋值 */
            self.collapseFrame = CGRect(x: pointXOfCollapse, y: pointY,
                width: 0, height: self.frame.height)
            self.expansionFrame = CGRect(x: pointXOfExpansion, y: pointY,
                width: self.expansionFrame!.width, height: self.frame.height)
            self.frame = self.collapseFrame!
    }
    
    private func dismissPopBarView() {
        self.nibView?.hidden = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = self.collapseFrame!
            }, completion: { (finish) -> Void in
                self.popBarViewHasShow = false
                self.hidden = true
        })
    }
    
    private func showPopBarView() {
        self.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.frame = self.expansionFrame!
            }) { (finish) -> Void in
                self.nibView?.hidden = false
                self.popBarViewHasShow = true
                _lastPopBarView = self
        }
    }
    
    internal func togglePopBar(frame: CGRect?) {
        
        if !self.initCalculate {
            if let _ = frame {
                self.initCalculateRelativePosition(frame!)
            }
            self.initCalculate = true
        }
        
        if self.popBarViewHasShow {
            self.dismissPopBarView()
            _lastPopBarView = nil
        } else {
            _autoClosePopBarView()
            self.showPopBarView()
        }
    }
}
