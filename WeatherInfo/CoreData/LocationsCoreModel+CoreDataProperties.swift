//
//  LocationsCoreModel+CoreDataProperties.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//
//

import Foundation
import CoreData


extension LocationsCoreModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationsCoreModel> {
        return NSFetchRequest<LocationsCoreModel>(entityName: "LocationsCoreModel")
    }

    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var address: String?

}

extension LocationsCoreModel : Identifiable {

}
