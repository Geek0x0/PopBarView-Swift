//
//  popBarView.swift
//
//  Created by 史凯迪 on 15/8/12.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

class popBarView: UIView {
    /* 激活按钮 */
    internal var ActiveBtn: popBarViewButton?
    
    /* 大小 */
    private var viewFrameBeforePop: CGRect!
    private var viewFrameAfterPop: CGRect!
    
    /* 默认按钮 (赞和分享)*/
    private var useDefaultButton: Bool = true
    private var greatButton: UIButton!
    private var shareButton: UIButton!
    internal var greatBtnAction: (() -> Void)!
    internal var shareBtnAction: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewFrameBeforePop = frame
        /* 圆角边框 */
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        
        /* 默认仅仅添加两个按钮，赞和分享 */
        self.addDefaultButton()
    }
    
    /* 传入自定义的Buttons，仅仅处理添加 */
    convenience init(frame: CGRect, afterPopFrame: CGRect, buttons: [UIButton]?) {
        self.init(frame: frame)
        self.viewFrameAfterPop = afterPopFrame
        
        self.removeDefaultButton()
        
        if let addButtons = buttons {
            /* 计算每个Button的布局(平均分布) */
            let buttonWidth: CGFloat = (afterPopFrame.width / CGFloat(addButtons.count))
            let buttonHeight: CGFloat = afterPopFrame.height
            /* 添加自定义的按钮 */
            var buttonXOffset: CGFloat = 0
            for button in addButtons {
                button.frame = CGRect(x: buttonXOffset, y: 0,
                    width: buttonWidth, height: buttonHeight)
                self.addSubview(button)
                buttonXOffset += buttonWidth
            }
        }
    }
    
    private func addDefaultButton() {
        let defaultButtonAction: Selector = Selector("defaultBtnAction:")
        
        let greateButtonFrame: CGRect = CGRect(x: 0, y: 0,
            width: 50, height: 30)
        self.greatButton = self.createButton(greateButtonFrame,
            btnAction: defaultButtonAction)
        self.greatButton.tag = 0
        
        let shareButtonFrame: CGRect = CGRect(x: 50, y: 0,
            width: 50, height: 30)
        self.shareButton = self.createButton(shareButtonFrame,
            btnAction: defaultButtonAction)
        self.shareButton.tag = 1
        
        self.addSubview(greatButton)
        self.addSubview(shareButton)
    }
    
    private func removeDefaultButton() {
        self.greatButton.removeFromSuperview()
        self.shareButton.removeFromSuperview()
        
        self.greatButton = nil
        self.shareButton = nil
    }
    
    internal func setDefaultButtonSetTitle() {
        if let _ = self.greatButton {
            self.greatButton.setTitle("赞", forState: .Normal)
        }
        if let _ = self.shareButton {
            self.shareButton.setTitle("分享", forState: .Normal)
        }
    }
    
    private func createButton(frame: CGRect, btnAction: Selector) -> UIButton {
        let button: UIButton = UIButton(type: .Custom)
        button.frame = frame
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        button.addTarget(self, action: btnAction, forControlEvents: .TouchUpInside)
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    enum defaultBtnType: Int {
        case greatBtn = 0;
        case shareBtn = 1;
    }
    
    func defaultBtnAction(sender: UIButton) {
        let btnType: defaultBtnType = defaultBtnType(rawValue: sender.tag)!
        switch btnType {
        case .greatBtn:
            if let greatAction = self.greatBtnAction {
                greatAction()
            }
        case .shareBtn:
            if let shareAction = self.shareBtnAction {
                shareAction()
            }
        }
    }
}