//
//  DreamList+CoreDataProperties.swift
//  DreamLister
//
//  Created by Suhas on 15/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//
//

import Foundation
import CoreData


extension DreamList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DreamList> {
        return NSFetchRequest<DreamList>(entityName: "DreamList")
    }

    @NSManaged public var dreamDescription: String?
    @NSManaged public var extraInformation: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var target: String?
    @NSManaged public var title: String?

}
