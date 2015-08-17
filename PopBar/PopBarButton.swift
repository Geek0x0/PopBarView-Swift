//
//  PopBarButton.swift
//
//  Created by 史凯迪 on 15/8/17.
//  Copyright © 2015年 msy. All rights reserved.
//

import UIKit

class PopBarButton: UIButton {
    
    private var popBar: PopBar?
    private var addPopBar: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPopBar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initPopBar()
    }
    
    private func initPopBar() {
        let popBarFrame: CGRect = CGRectMake(0, 0,
            PopBarOptions.popBarWidth, PopBarOptions.popBarHeight)
        self.popBar = PopBar(frame: popBarFrame)
    }
    
    internal func togglePopBar() {
        if !self.addPopBar {
            self.superview?.addSubview(self.popBar!)
            self.addPopBar = true
        }
        self.popBar?.togglePopBar(self.frame)
    }
}
