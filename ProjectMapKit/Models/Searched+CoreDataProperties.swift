//
//  Searched+CoreDataProperties.swift
//  
//
//  Created by Marcus Nilsson on 2020-03-13.
//
//

import Foundation
import CoreData


extension Searched {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Searched> {
        return NSFetchRequest<Searched>(entityName: "Searched")
    }

    @NSManaged public var cityName: String?

}
