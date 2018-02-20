//
//  PLinkEntity+CoreDataProperties.swift
//  
//
//  Created by Myloi Mellanc on 2018. 2. 21..
//
//

import Foundation
import CoreData


extension PLinkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PLinkEntity> {
        return NSFetchRequest<PLinkEntity>(entityName: "PLinkEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var type: Int32
    @NSManaged public var node1_id: Int32
    @NSManaged public var node2_id: Int32

}
