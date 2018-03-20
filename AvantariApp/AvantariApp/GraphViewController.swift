//
//  GraphViewController.swift
//  AvantariApp
//
//  Created by Sanjay Shingarwad on 16/03/18.
//  Copyright © 2018 Sanjay Shingarwad. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class GraphViewController: UIViewController {

    @IBOutlet weak var curvedlineChart: LineChart!

    @IBOutlet weak var totalDataLabel: UILabel!
    let dataHelper = CoreDataHelper()

    @IBOutlet weak var randomNumLabel: UILabel!

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ChartEntity> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<ChartEntity> = ChartEntity.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().delegate = self
        self.updateGraphData(entities: nil)

        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Graph Data Methods
extension GraphViewController {
    
    func getGraphDataPoints(entities:[NSManagedObject]) -> [PointEntry] {
        //format and update graph view
        var result: [PointEntry] = []
        for entitiy in entities {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = entitiy.value(forKey: "date") as! Date
            date.addTimeInterval(TimeInterval(24 * 60 * 60))
            result.append(PointEntry(value: entitiy.value(forKey: "index") as! Int, label: formatter.string(from: date)))
        }
        return result
    }
    
    func updateGraphData(entities:[NSManagedObject]?) {
        let dataList =  (entities != nil) ? entities! : self.dataHelper.fetchRecordsForEntity("ChartEntity", inManagedObjectContext: CoreDataManager.shared.managedObjectContext)
        if dataList.count > 1 {
            let dataEntries = getGraphDataPoints(entities: dataList)
            curvedlineChart.dataEntries = dataEntries
        }
        curvedlineChart.isCurved = true
    }
}

// MARK:- UNUserNotificationCenterDelegate

extension GraphViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

// MARK:- NSFetchedResultsControllerDelegate

extension GraphViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       
        if let fetchObjects = controller.fetchedObjects, let chartEntity = fetchObjects.last as? ChartEntity {
            self.totalDataLabel.text = "Total Random Nos: \(fetchObjects.count)"
            self.randomNumLabel.text = "\(chartEntity.index)"
            let lastInsertedItems = fetchObjects.suffix(10)
            self.updateGraphData(entities: Array(lastInsertedItems) as? [NSManagedObject])
        }
    }
}

