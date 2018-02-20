//
//  PNodeEntity+CoreDataProperties.swift
//  
//
//  Created by Myloi Mellanc on 2018. 2. 21..
//
//

import Foundation
import CoreData


extension PNodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PNodeEntity> {
        return NSFetchRequest<PNodeEntity>(entityName: "PNodeEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var text: String?
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var type: Int32

}
