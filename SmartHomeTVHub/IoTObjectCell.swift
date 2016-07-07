//
//  ObjectCell.swift
//  SmartHomeTVHub
//
//  Created by Keith Martin on 6/9/16.
//  Copyright © 2016 Keith Martin. All rights reserved.
//

import UIKit
import PubNub

//Super class that all object cells inherit 
class IoTObjectCell: UICollectionViewCell, PNObjectEventListener {
    
    var progressView: UIProgressView!
    var objectImage: UIImageView!
    var temperature: UILabel!
    var objectTitle: UILabel!
    var offButton: UIButton!
    var onButton: UIButton!
    var progressBarTimer: NSTimer!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(250, 250, 50, 50)) as UIActivityIndicatorView
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //Set cell view pertaining to which object it is
    func configureCell(object: String, state: String) {}
    
    func toggleOffButton(sender: AnyObject) {}
    
    func toggleOnButton(sender: AnyObject) {}
    
    //Dialogue showing error
    func showAlert(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion:nil)
    }
    
    //Update progress bar for change in temperature sensor
    func updateProgressBar(progress: Float) {
        self.progressView.progress = progress
        if(self.progressView.progress == 1.0) {
            self.progressView.removeFromSuperview()
        }
    }
    
    //Spinning indicator when loading request
    func showActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
    }
}
