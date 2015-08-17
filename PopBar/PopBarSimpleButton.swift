//
//  popBarViewButton.swift
//
//  Created by 史凯迪 on 15/8/12.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

/* 用于外部关闭最后一个打开的 */
var _lastPopBarButtomView: popViewBase?
/* 自动关闭弹出条菜单 */
func _autoClosePopBarButtonView() {
    if let _ = _lastPopBarButtomView {
        if let _ = _lastPopBarButtomView?.ActiveBtn {
            _lastPopBarButtomView?.ActiveBtn?.togglePopView(nil)
        }
    }
}

/* 弹出的方向 */
enum popViewDirection: Int {
    case popToLeft = 1;
    case popToRight = 2;
}
/* 开启的弹出条类型 */
enum popViewType: Int {
    case defaultPopBarView = 1;
    case customPopBarView = 2;
}
/* 传入的弹出条类型 */
enum setPopViewType: Int {
    case nib = 1;
    case view = 2;
}

/* 弹出的大小设定, 更具需要修改 */
struct PopBarSimpleOptions {
    static var popBarViewWidth: CGFloat = 100
    static var popBarViewHeight: CGFloat = 30
    static var popbarViewDistanceWithButton: CGFloat = 1
    static var popDirection: popViewDirection = .popToLeft
}

class PopBarButtonSimple: UIButton {
    
    /* 开启的弹出条 */
    private var xpopViewType: popViewType!
    private var xpopBarView: PopBarViewSimple?
    private var xcusPopView: popViewBase?
    
    /* 计算弹出的Frame */
    private var popBarViewOriginalFrame: CGRect!
    private var popBarViewFrame: CGRect!
    
    /* 判断 */
    private var popBarViewHasInit: Bool = false
    private var popBarViewHasShow: Bool = false
    private var customPopBarView: Bool = false
    private var actionAfterPop: (() -> Void)!
    
    /* 标准初始化方法 */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xpopViewType = .defaultPopBarView
    }
    
    /* 默认仅有两个Button的View */
    convenience init(frame: CGRect, greateAction: (() -> Void),
        shareAction: (() -> Void)) {
            self.init(frame: frame)
            self.initDefaultSimplePopBarView(frame)
            self.setDefaultAction(greateAction, shareAction: shareAction)
    }
    
    /* 自定义多个Button的View */
    convenience init(frame: CGRect, afterPopFrame: CGRect,
        popBarViewBtns: [UIButton]?, actionAfterPop: (() -> Void)?) {
            self.init(frame: frame)
            
            if let buttons = popBarViewBtns {
                self.customPopBarView = true
                self.actionAfterPop = actionAfterPop
                self.xpopBarView = PopBarViewSimple(frame: self.popBarViewOriginalFrame,
                    afterPopFrame: self.popBarViewFrame, buttons: buttons)
            }
    }
    
    /* 自定义一个View显示 */
    convenience init(frame: CGRect, popView: UIView, popViewFrame: CGRect) {
        self.init(frame: frame)
        self.initPopViewWithView(popView, setViewFrame: popViewFrame)
    }
    
    /* 自定义一个NIB文件的View显示 */
    convenience init(frame: CGRect, popNib: UINib, nibIndex: Int, popViewFrame: CGRect) {
        self.init(frame: frame)
        
        self.initPopViewWithNib(popNib, setIndex: nibIndex, setViewFrame: popViewFrame)
    }
    
    private func initPopViewWithView(setView: UIView, setViewFrame: CGRect) {
        self.xpopViewType = .customPopBarView
        
        self.xcusPopView = (setView as! popViewBase)
        self.xcusPopView?.frame = setViewFrame
    }
    
    private func initPopViewWithNib(setNib: UINib, setIndex: Int, setViewFrame: CGRect) {
        self.xpopViewType = .customPopBarView
        
        let Xview: UIView =
            setNib.instantiateWithOwner(nil, options: nil)[setIndex] as! popViewBase
        Xview.frame = setViewFrame
        
        self.xcusPopView = (Xview as! popViewBase)
        self.xcusPopView?.frame = setViewFrame
    }
    
    private func initDefaultSimplePopBarView(buttonFrame: CGRect) {
        
        var popBarViewOriginalX: CGFloat = 0
        var popBarViewX: CGFloat = 0
        var popBarViewY: CGFloat = 0
        
        /* 计算弹出视图的位置 */
        if buttonFrame.height > PopBarSimpleOptions.popBarViewHeight{
            popBarViewY = buttonFrame.origin.y +
                ((buttonFrame.height - PopBarSimpleOptions.popBarViewHeight) / 2)
        } else {
            popBarViewY = buttonFrame.origin.y -
                ((PopBarSimpleOptions.popBarViewHeight - buttonFrame.height) / 2)
        }
        switch PopBarSimpleOptions.popDirection {
        case .popToLeft:
            popBarViewOriginalX =
                buttonFrame.origin.x - PopBarSimpleOptions.popbarViewDistanceWithButton
            popBarViewX =
                buttonFrame.origin.x -
                (PopBarSimpleOptions.popbarViewDistanceWithButton + PopBarSimpleOptions.popBarViewWidth)
        case .popToRight:
            popBarViewOriginalX =
                buttonFrame.origin.x + PopBarSimpleOptions.popbarViewDistanceWithButton
            popBarViewX =
                buttonFrame.origin.x +
                (PopBarSimpleOptions.popbarViewDistanceWithButton + PopBarSimpleOptions.popBarViewWidth)
            break
        }
        
        /* 初始化的位置 */
        self.popBarViewOriginalFrame =
            CGRect(x: popBarViewOriginalX, y: popBarViewY,
                width: 0, height: PopBarSimpleOptions.popBarViewHeight)
        /* 弹出后的位置 */
        self.popBarViewFrame =
            CGRect(x: popBarViewX, y: popBarViewY,
                width: PopBarSimpleOptions.popBarViewWidth,
                height: PopBarSimpleOptions.popBarViewHeight)
        /* 默认初始化 */
        self.xpopBarView = PopBarViewSimple(frame: self.popBarViewOriginalFrame,
            useDefault: true)
        self.xpopBarView?.ActiveBtn = self
        
        /* 已初始化标记 */
        self.popBarViewHasInit = true
    }
    
    
    /* waitting.... */
    private func initCustomPopBarView(buttonFrame: CGRect) {
        
    }
    
    private func initPopBarView(buttonFrame: CGRect) {
        switch self.xpopViewType! {
        case .customPopBarView:
            self.initCustomPopBarView(buttonFrame)
        case .defaultPopBarView:
            self.initDefaultSimplePopBarView(buttonFrame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xpopViewType = .defaultPopBarView
    }
    
    private func showPopBarView() {
        self.popBarViewHasShow = true
        
        _lastPopBarButtomView = self.xpopBarView
        
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
    
    internal func togglePopView(buttonFrame: CGRect?) {
        
        if !self.popBarViewHasInit {
            if let Bframe = buttonFrame {
                self.initPopBarView(Bframe)
            }
        }
        
        if self.popBarViewHasShow {
            self.dismissPopBarView()
            _lastPopBarButtomView = nil
        } else {
            if let _ = _lastPopBarButtomView {
                _autoClosePopBarButtonView()
            }
            self.showPopBarView()
        }
    }
    
    deinit {
        self.xpopBarView = nil
    }
}