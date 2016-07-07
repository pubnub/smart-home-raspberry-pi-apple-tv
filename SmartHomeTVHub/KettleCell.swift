//
//  Kettle.swift
//  SmartHomeTVHub
//
//  Created by Keith Martin on 6/23/16.
//  Copyright © 2016 Keith Martin. All rights reserved.
//

import Foundation
import UIKit
import PubNub

class KettleCell: IoTObjectCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        objectTitle = UILabel(frame: CGRect(x: 90, y: 453, width: 320, height: 39))
        objectTitle.textAlignment = .Center
        objectTitle.font = UIFont(name: "SFUIDisplay-Medium", size: 24)
        temperature = UILabel(frame: CGRect(x: 0, y: 23, width: 500, height: 300))
        temperature.textAlignment = .Center
        temperature.font = UIFont(name: "SFUIDisplay-Light", size: 200)
        temperature.adjustsFontSizeToFitWidth = true
        progressView = UIProgressView(frame: CGRect(x: 0, y: 256, width: 500, height: 10))
        progressView.progressTintColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0)
        contentView.addSubview(objectTitle)
        contentView.addSubview(temperature)
        contentView.addSubview(progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCell(object: String, state: String) {
        temperature.text = NSString(format:"\(state)%@", "\u{00B0}C") as String
        objectTitle.text = "Tea Kettle"
        if let kettleTemp = Float(state) {
            progressView.progress = kettleTemp/100
            if(progressView.progress == 1.0) {
                temperature.text = "Water is boiled!"
            }
        }
    }
}