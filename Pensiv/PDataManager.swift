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
    
    let delegates : AppDelegate
    
    let persistentContainer : NSPersistentContainer
    
    init(mother : AppDelegate)
    {
        self.delegates = mother
        self.persistentContainer = mother.persistentContainer
    }
    
    func saveNodeData(nodelist : Set<PNode>) {
        let managedContext = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PNodeEntity", in: managedContext)
        
        let pNodeEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        for node in nodelist {
            pNodeEntity.setValue(node.nodeID, forKey: "id")
            pNodeEntity.setValue(node.frame.origin.x, forKey: "x")
            pNodeEntity.setValue(node.frame.origin.y, forKey: "y")
            pNodeEntity.setValue(node.frame.size.width, forKey: "width")
            pNodeEntity.setValue(node.frame.size.height, forKey: "height")
            pNodeEntity.setValue(node.type, forKey: "type")
            
            if node.type == .TEXT {
                pNodeEntity.setValue((node as! PTextNode).textfield.stringValue, forKey: "text")
            }
            else {
                pNodeEntity.setValue(nil, forKey: "text")
            }
            
            do {
                try managedContext.save()
                
                print("Database Saved - Node ID : \(node.nodeID)")
                
            } catch let error as NSError {
                print("You Could Not Save, \(error), \(error.userInfo)" )
            }
        }
    }
    
    func saveLinkData(linklist : Set<PLink>) {
        let managedContext = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PLinkEntity", in: managedContext)
        
        let pLinkEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
        for link in linklist {
            pLinkEntity.setValue(link.linkID, forKey: "id")
            pLinkEntity.setValue(link.type, forKey: "type")
            
            let tuple = link.getNodes()
            pLinkEntity.setValue(tuple.0, forKey: "node1_id")
            pLinkEntity.setValue(tuple.1, forKey: "node2_id")
            
            do {
                try managedContext.save()
                
                print("Database Saved - Link ID : \(link.linkID)")
                
            } catch let error as NSError {
                print("You Could Not Save, \(error), \(error.userInfo)" )
            }
        }
        
        
    }
    
    func saveData(view : PCustomDocumentView)
    {
        self.saveNodeData(nodelist: view.nodeList)
        self.saveLinkData(linklist: view.linkList)
        
        delegates.saveAction(nil)
    }
    
    func loadData() {
        
    }
    
}
