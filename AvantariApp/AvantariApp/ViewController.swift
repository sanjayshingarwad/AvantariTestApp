//
//  ViewController.swift
//  AvantariApp
//
//  Created by Sanjay Shingarwad on 13/03/18.
//  Copyright © 2018 Sanjay Shingarwad. All rights reserved.
//

import UIKit


let SocketConnected = "SocketConnected"
let SocketDisconneced = "SocketConnected"

class ViewController: UIViewController {
    
    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure User Notification Center
        self.addObservers()

    }
    
    func addObservers() {
        //add observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.socketIsConnected), name: NSNotification.Name(rawValue: SocketConnected), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.socketIsDisconnected), name: NSNotification.Name(rawValue: SocketDisconneced), object: nil)
    }

    @IBAction func connectButtonClicked(_ sender: Any) {
        self.connectButton.isEnabled = false
        //Establish socket connection
        SocketConnectionManager.connectionManager.startConnection()
    }
    
    @objc func socketIsConnected() {
        self.connectButton.isEnabled = true
        self.connectButton.setTitle("Disconnect", for: .normal)
        self.performSegue(withIdentifier: "GraphViewPushSeague", sender: nil)
        
    }
    
    @objc func socketIsDisconnected() {
        self.connectButton.isEnabled = true
        self.connectButton.setTitle("Connected", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
