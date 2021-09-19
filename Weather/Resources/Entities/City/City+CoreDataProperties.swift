//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Alexander Rubtsov on 13.09.2021.
//
//

import Foundation
import CoreData

extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var orderPosition: Int32

}

extension City: Identifiable {

}
