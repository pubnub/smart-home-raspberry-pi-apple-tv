//
//  Thermostat.swift
//  SmartHomeTVHub
//
//  Created by Keith Martin on 6/23/16.
//  Copyright © 2016 Keith Martin. All rights reserved.
//

import Foundation
import PubNub

class ThermostatCell: IoTObjectCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        offButton = UIButton(type: .System) as UIButton
        offButton.frame = CGRect(x: 90, y: 354, width: 146, height: 67)
        offButton.addTarget(self, action: #selector(toggleOffButton), forControlEvents: .PrimaryActionTriggered)
        offButton.titleLabel?.font = UIFont(name: "SFUIDisplay-Light", size: 20)
        onButton = UIButton(type: .System) as UIButton
        onButton.frame = CGRect(x: 265, y: 354, width: 146, height: 67)
        onButton.addTarget(self, action: #selector(toggleOnButton), forControlEvents: .PrimaryActionTriggered)
        onButton.titleLabel?.font = UIFont(name: "SFUIDisplay-Light", size: 20)
        objectTitle = UILabel(frame: CGRect(x: 90, y: 453, width: 320, height: 39))
        objectTitle.textAlignment = .Center
        objectTitle.font = UIFont(name: "SFUIDisplay-Medium", size: 24)
        temperature = UILabel(frame: CGRect(x: 0, y: 23, width: 500, height: 300))
        temperature.textAlignment = .Center
        temperature.font = UIFont(name: "SFUIDisplay-Light", size: 200)
        contentView.addSubview(offButton)
        contentView.addSubview(onButton)
        contentView.addSubview(objectTitle)
        contentView.addSubview(temperature)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configureCell(object: String, state: String) {
        temperature.text = NSString(format:"\(state)%@", "\u{00B0}F") as String
        objectTitle.text = "Thermostat"
        offButton.setTitle("-", forState: .Normal)
        onButton.setTitle("+", forState: .Normal)
    }
    
    //Turn thermostat temperature display up by one
    override func toggleOffButton(sender: AnyObject) {
        if let strippedTemp = self.temperature.text?.stringByReplacingOccurrencesOfString("\u{00B0}F", withString: "") {
            appDelegate.client.publish(["thermostat" : String(Int(strippedTemp)! - 1)], toChannel: "Smart_Home", withCompletion: { (status) in
                self.showActivityIndicator()
                if status.error {
                    self.showAlert(status.errorData.information)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.temperature.text = NSString(format:"\(String(Int(strippedTemp)! - 1))%@", "\u{00B0}F") as String
                    })
                }
            })
        }
    }
    
    //Turn thermostat temperature display up by one
    override func toggleOnButton(sender: AnyObject) {
        if let strippedTemp = self.temperature.text?.stringByReplacingOccurrencesOfString("\u{00B0}F", withString: "") {
            appDelegate.client.publish(["thermostat" : String(Int(strippedTemp)! + 1)], toChannel: "Smart_Home", withCompletion: { (status) in
                self.showActivityIndicator()
                if status.error {
                    self.showAlert(status.errorData.information)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.temperature.text = NSString(format:"\(String(Int(strippedTemp)! + 1))%@", "\u{00B0}F") as String
                    })
                }
            })
        }
    }
}
