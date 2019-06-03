//
//  UIViewController+Extension.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/13/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//
import UIKit
import SwiftMessages

extension UIViewController {
    func disPlayError(_ errorMessage: String) {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: errorMessage)
        error.button?.setTitle("Stop", for: .normal)
        SwiftMessages.show(view: error)
    }
    
    func displayInfo(_ message: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "Message", body: message)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .center
        infoConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: infoConfig, view: info)
    }
}
