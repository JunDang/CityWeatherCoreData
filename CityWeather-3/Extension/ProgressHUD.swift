//
//  ProgressHUD.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-08-03.
//  Copyright © 2018 Jun Dang. All rights reserved.
//
import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .regular)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        activityIndictor.startAnimating()
        let height: CGFloat = 50.0
        self.frame = CGRect(x: 123,
                            y: 100, width: 180, height: height)
        vibrancyView.frame = self.bounds
        
        let activityIndicatorSize: CGFloat = 30
        activityIndictor.frame = CGRect(x: 5, y: height / 2 - activityIndicatorSize / 2,
                                        width: activityIndicatorSize,
                                        height: activityIndicatorSize)
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        label.text = text
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: activityIndicatorSize + 5, y: 0, width: 100 - activityIndicatorSize, height: height)
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
