//
//  popBarViewButton.swift
//
//  Created by 史凯迪 on 15/8/12.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

/* 用于外部关闭最后一个打开的 */
var lastPopBarView: popBarView?
/* 自动关闭弹出条菜单 */
func autoClosePopBarView() {
    if let _ = lastPopBarView {
        if let _ = lastPopBarView?.ActiveBtn {
            lastPopBarView?.ActiveBtn?.togglePopView((lastPopBarView?.ActiveBtn?.frame)!)
        }
    }
}

class popBarViewButton: UIButton {
    
    /* 开启的弹出条按钮 */
    private var xpopBarView: popBarView?
    
    /* 弹出的方向 */
    enum popViewDirection: Int {
        case popToLeft = 1;
        case popToRight = 2;
    }
    
    /* 弹出的大小设定, 更具需要修改 */
    let popBarViewWidth: CGFloat = 100
    let popBarViewHeight: CGFloat = 30
    let popbarViewDistanceWithButton: CGFloat = 1
    let popDirection: popViewDirection = .popToLeft
    
    /* 计算弹出的Frame */
    private var popBarViewOriginalFrame: CGRect!
    private var popBarViewFrame: CGRect!
    
    /* 判断 */
    private var popBarViewHasInit: Bool = false
    private var popBarViewHasShow: Bool = false
    private var customPopBarView: Bool = false
    private var actionAfterPop: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPopBarView(frame)
    }
    
    convenience init(frame: CGRect, greateAction: (() -> Void),
        shareAction: (() -> Void)) {
            self.init(frame: frame)
            self.setDefaultAction(greateAction, shareAction: shareAction)
    }
    
    convenience init(frame: CGRect, afterPopFrame: CGRect,
        popBarViewBtns: [UIButton]?, actionAfterPop: (() -> Void)?) {
            self.init(frame: frame)
            
            if let buttons = popBarViewBtns {
                self.customPopBarView = true
                self.actionAfterPop = actionAfterPop
                self.xpopBarView = popBarView(frame: self.popBarViewOriginalFrame,
                    afterPopFrame: self.popBarViewFrame, buttons: buttons)
            }
    }
    
    private func initPopBarView(buttonFrame: CGRect) {
        
        var popBarViewOriginalX: CGFloat = 0
        var popBarViewX: CGFloat = 0
        var popBarViewY: CGFloat = 0
        
        /* 计算弹出视图的位置 */
        if buttonFrame.height > self.popBarViewHeight{
           popBarViewY = buttonFrame.origin.y + ((buttonFrame.height - self.popBarViewHeight) / 2)
        } else {
            popBarViewY = buttonFrame.origin.y - ((self.popBarViewHeight - buttonFrame.height) / 2)
        }
        switch self.popDirection {
        case .popToLeft:
            popBarViewOriginalX =
                buttonFrame.origin.x - popbarViewDistanceWithButton
            popBarViewX =
                buttonFrame.origin.x - (popbarViewDistanceWithButton + self.popBarViewWidth)
        case .popToRight:
            popBarViewOriginalX =
                buttonFrame.origin.x + popbarViewDistanceWithButton
            popBarViewX =
                buttonFrame.origin.x + (popbarViewDistanceWithButton + self.popBarViewWidth)
            break
        }
        
        /* 初始化的位置 */
        self.popBarViewOriginalFrame =
            CGRect(x: popBarViewOriginalX, y: popBarViewY,
                width: 0, height: popBarViewHeight)
        /* 弹出后的位置 */
        self.popBarViewFrame =
            CGRect(x: popBarViewX, y: popBarViewY,
                width: self.popBarViewWidth, height: self.popBarViewHeight)
        /* 默认初始化 */
        self.xpopBarView = popBarView(frame: self.popBarViewOriginalFrame)
        self.xpopBarView?.ActiveBtn = self
        
        /* 已初始化标记 */
        self.popBarViewHasInit = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func showPopBarView() {
        self.popBarViewHasShow = true
        
        lastPopBarView = self.xpopBarView
        
        self.xpopBarView!.backgroundColor = UIColor.grayColor()
        self.superview?.addSubview(self.xpopBarView!)
        
        UIView.animateWithDuration(0.3, delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.xpopBarView!.frame = self.popBarViewFrame
            }) { (finish) -> Void in
                if self.customPopBarView {
                    self.actionAfterPop()
                } else {
                    self.xpopBarView?.setDefaultButtonSetTitle()
                }
        }
    }
    
    private func dismissPopBarView() {
        self.popBarViewHasShow = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.xpopBarView!.frame = self.popBarViewOriginalFrame
            }, completion: { (finish) -> Void in
                self.xpopBarView?.removeFromSuperview()
        })
    }
    
    internal func setDefaultAction(greatAction: (() -> Void)?,
        shareAction: (() -> Void)?) {
            self.xpopBarView?.greatBtnAction = greatAction
            self.xpopBarView?.shareBtnAction = shareAction
    }
    
    internal func togglePopView(buttonFrame: CGRect) {
        if !self.popBarViewHasInit {
            self.initPopBarView(buttonFrame)
        }
        
        if self.popBarViewHasShow {
            self.dismissPopBarView()
            lastPopBarView = nil
        } else {
            if let _ = lastPopBarView {
                autoClosePopBarView()
            }
            self.showPopBarView()
        }
    }
    
    deinit {
        self.xpopBarView = nil
    }
}