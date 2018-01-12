//
//  PDataManager.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 12..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreData


class PDataManager
{
    var nodes = [NSManagedObject]()
    
    var delegates : AppDelegate?
    
    init(mother : AppDelegate)
    {
        delegates = mother
    }
    
    func saveData(str : String)
    {
        let managedContext = delegates?.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PNodeEntity", in: managedContext!)
        
        let pnodeEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        pnodeEntity.setValue(str, forKey: "str")
        
        do {
            try managedContext?.save()
            nodes.append(pnodeEntity)
            
            print("DataBase Count : \(nodes.count)")
            
        } catch let error as NSError {
            print("You Could Not Save, \(error), \(error.userInfo)" )
        }
    }
    
}
