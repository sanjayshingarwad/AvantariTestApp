//
//  SocketConnectionManager.swift
//  AvantariApp
//
//  Created by Sanjay Shingarwad on 13/03/18.
//  Copyright © 2018 Sanjay Shingarwad. All rights reserved.
//

let serverURLString = "http://ios-test.us-east-1.elasticbeanstalk.com"
let nameSpace = "/random"

import Foundation
import SocketIO

class SocketConnectionManager {
    
    var socketManager: SocketManager!
    var socket: SocketIOClient!
    var isConnected: Bool = false
    static let connectionManager = SocketConnectionManager()
    var chartEnityValue = 0
    
    /// Make socket connection
    func startConnection() {
        
        socketManager = SocketManager(socketURL: URL(string: serverURLString)!, config: [.log(true), .compress])
        socket = socketManager.socket(forNamespace: nameSpace);

        socket.on(clientEvent: .connect) {data, ack in
            self.isConnected = true
            print("socket connected")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketConnected), object: nil)
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            self.isConnected = false
            print("socket disconnected")
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: SocketDisconneced), object: nil)
        }
        
        socket.on("capture") {data, ack in
            guard let chartItemValue = data[0] as? Int else { return }
            print("Got event: \(chartItemValue)")
            if chartItemValue < 11  {
                //add to DB
                if CoreDataHelper().addChartEntity(chartValue: chartItemValue, managedObjectContext: CoreDataManager.shared.managedObjectContext) != nil {
                    print("Chart Entity Added to DB")
                }
            }
            //shedule notification
            if self.chartEnityValue == chartItemValue {
                LocalNotificationManager().scheduleLocalNotification(chartEntityValue:chartItemValue)
            }
            self.chartEnityValue = chartItemValue
        }
        socket.connect()
       // socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
    }
}
