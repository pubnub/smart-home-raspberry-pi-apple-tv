//
//  ViewController.swift
//  SmartHomeTVHub
//
//  Created by Keith Martin on 6/9/16.
//  Copyright © 2016 Keith Martin. All rights reserved.
//

import UIKit
import PubNub

class SmartHubViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PNObjectEventListener {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var objectStates: [String : String] = [:]
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var objectStatesSet: Bool = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(960, 540, 50, 50)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self
        collectionView.delegate = self
        appDelegate.client.addListener(self)
        appDelegate.client.subscribeToChannels(["Smart_Home"], withPresence: true)
        showActivityIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        if let receivedobjectStates = message.data.message as? [String : String] {
            //Receive initial object states when first subscribing to the channel
            if !objectStatesSet {
                objectStates = receivedobjectStates
                activityIndicator.stopAnimating()
                collectionView.reloadData()
                objectStatesSet = true
                //Receive temperature sensor updates
            } else if let kettleTemp = receivedobjectStates["temp"] {
                objectStates["temp"] = kettleTemp
                collectionView.reloadData()
            }
        }
    }
    
    //Create and set cells for UI
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch Array(objectStates.keys)[indexPath.row] {
        case "light":
            collectionView.registerClass(LightBulbCell.self, forCellWithReuseIdentifier: "lightCell")
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lightCell", forIndexPath: indexPath) as! LightBulbCell
            let object = Array(objectStates.keys)[indexPath.row]
            let state = Array(objectStates.values)[indexPath.row]
            cell.configureCell(object, state: state)
            return cell
        case "temp":
            collectionView.registerClass(KettleCell.self, forCellWithReuseIdentifier: "kettleCell")
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("kettleCell", forIndexPath: indexPath) as! KettleCell
            let object = Array(objectStates.keys)[indexPath.row]
            let state = Array(objectStates.values)[indexPath.row]
            cell.configureCell(object, state: state)
            return cell
        case "thermostat":
            collectionView.registerClass(ThermostatCell.self, forCellWithReuseIdentifier: "thermostatCell")
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("thermostatCell", forIndexPath: indexPath) as! ThermostatCell
            let object = Array(objectStates.keys)[indexPath.row]
            let state = Array(objectStates.values)[indexPath.row]
            cell.configureCell(object, state: state)
            return cell
        default:
            collectionView.registerClass(IoTObjectCell.self, forCellWithReuseIdentifier: "objectCell")
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("objectCell", forIndexPath: indexPath)
            cell.hidden = true
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objectStates.count
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //Spinning indicator when loading request
    func showActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //Dialogue showing error
    func showAlert(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
}

