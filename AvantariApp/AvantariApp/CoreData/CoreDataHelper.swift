//
//  CoreDataHelper.swift
//  AvantariApp
//
//  Created by Sanjay Shingarwad on 14/03/18.
//  Copyright © 2018 Sanjay Shingarwad. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    // MARK: - Helper Methods
    
    func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        return result
    }
    
    func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.fetchLimit = 10
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        result = result.reversed()
        return result
    }
    
    func addChartEntity(chartValue: Int, managedObjectContext: NSManagedObjectContext ) -> Bool? {
        if let chartEntity = self.createRecordForEntity("ChartEntity", inManagedObjectContext: managedObjectContext) {
            chartEntity.setValue(chartValue, forKeyPath: "index")
            chartEntity.setValue(Date(), forKey: "date")
        }
        
        do {
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }
}
