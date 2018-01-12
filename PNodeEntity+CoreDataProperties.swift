//
//  PNodeEntity+CoreDataProperties.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 12..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//
//

import Foundation
import CoreData


extension PNodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PNodeEntity> {
        return NSFetchRequest<PNodeEntity>(entityName: "PNodeEntity")
    }

    @NSManaged public var str: String?
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var id: Int64
    @NSManaged public var mother_id: Int64

}
