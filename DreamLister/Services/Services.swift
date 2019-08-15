//
//  Services.swift
//  DreamLister
//
//  Created by Suhas on 15/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import Foundation
import CoreData

class Services {
    
    func addDataToCoreData(documents: [NSDictionary]) {
        let moc = CoreDataStack().persistentContainer.viewContext
        self.deleteDataFromCoreData()
        for document in documents
        {
            let dreamList = DreamList(context: moc)
            dreamList.dreamDescription = document["description"] as? String
            dreamList.extraInformation = document["information"] as? String
            dreamList.title = document["title"] as? String
            dreamList.target = document["target"] as? String
            do {
                try moc.save()
            } catch let error as NSError {
                print("Storing to Core Data went wrong")
            }
        }
        
    }
    
    func getDataFromCoreData() -> [NSDictionary] {
        let moc = CoreDataStack().persistentContainer.viewContext
        let request: NSFetchRequest = DreamList.fetchRequest()
        do {
            let result = try moc.fetch(request)
            if result.count > 0 {
                var dreamList:[NSDictionary] = []
                for item in result {
                    dreamList.append(["description": item.dreamDescription, "information": item.extraInformation, "title": item.title, "target": item.target])
                }
                return dreamList
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return []
    }
    
    func deleteDataFromCoreData() {
        let moc = CoreDataStack().persistentContainer.viewContext
        let request:NSFetchRequest = DreamList.fetchRequest()
        do {
            let result = try moc.fetch(request)
            if result.count > 0 {
                for item in result {
                    moc.delete(item)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
