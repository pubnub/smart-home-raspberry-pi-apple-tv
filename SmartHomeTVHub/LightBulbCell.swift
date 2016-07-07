//
//  LightBulb.swift
//  SmartHomeTVHub
//
//  Created by Keith Martin on 6/23/16.
//  Copyright © 2016 Keith Martin. All rights reserved.
//

import Foundation
import UIKit
import PubNub

class LightBulbCell: IoTObjectCell {
    
    
    override func configureCell(object: String, state: String) {
        objectImage.image = UIImage(named: "\(object)_\(state)")
        objectTitle.text = "Bedroom light"
        offButton.setTitle("Off", forState: .Normal)
        onButton.setTitle("On", forState: .Normal)
    }
    
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
        objectTitle.translatesAutoresizingMaskIntoConstraints = false
        objectImage = UIImageView(frame: CGRect(x: 150, y: 50, width: 200, height: 200))
        contentView.addSubview(offButton)
        contentView.addSubview(onButton)
        contentView.addSubview(objectTitle)
        contentView.addSubview(objectImage)
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Turn light off
    override func toggleOffButton(sender: AnyObject) {
        appDelegate.client.publish(["light" : "off"], toChannel: "Smart_Home", withCompletion: { (status) in
            self.showActivityIndicator()
            if status.error {
                self.showAlert(status.errorData.description)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.objectImage.image = UIImage(named: "light_off")
                })
            }
        })
    }
    
    //Turn light on
    override func toggleOnButton(sender: AnyObject) {
        appDelegate.client.publish(["light" : "on"], toChannel: "Smart_Home", withCompletion: { (status) in
            self.showActivityIndicator()
            if status.error {
                self.showAlert(status.errorData.description)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.objectImage.image = UIImage(named: "light_on")
                })
            }
        })
    }
}
