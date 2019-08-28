//
//  UIView+Extension.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {
    public func showToastAtBottom(message: String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .black
        self.makeToast(message, duration: 3.0, position: .bottom, style: style)
    }
}
