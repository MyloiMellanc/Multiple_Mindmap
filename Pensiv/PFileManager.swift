//
//  PFileManager.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 4. 24..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Kanna

class PFileManager
{
    init() {
    
    }
    
    private func createNodeXML(node : PNode) -> String {
        let position = node.frame.origin
        let type = node.getType()
        var str = """
                  <node>
                  <id>\(node.getID())</id>
                  <xpos>\(position.x)</xpos>
                  <ypos>\(position.y)</ypos>
                  """
        
        switch (type) {
        case .TEXT:
            let textnode = node as! PTextNode
            str.append("<type>TEXT</type>")
            str.append("<text>\(textnode.getText())</text>")
            
        case .CRAWLING:
            str.append("<type>CRAWLING</type>")
            
        case .ERROR:
            print("Node Type Error.")
        }
        
        str.append("</node>")
        
        return str
    }
    
    private func createLinkXML(node_1 : PNode, node_2 : PNode) -> String {
        var str = """
                  <link>
                  <node_1>\(node_1.getID())</node_1>
                  <node_2>\(node_2.getID())</node_2>
                  </link>
                  """
        
        return str
    }
    
    func save(view : PCustomDocumentView, filename : String, nodes : Set<PNode>, links : Set<PLink>) {
        var xml_str = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\">\n"
        
        for node in nodes {
            let str = self.createNodeXML(node: node)
            xml_str.append(str)
        }
        
        xml_str.append("\n")
        
        for link in links {
            let nodes = link.getNodes()
            let str = self.createLinkXML(node_1: nodes.0, node_2: nodes.1)
            xml_str.append(str)
        }
        
        //파일로 변환
    }
    
    
    
    var targetView : PCustomDocumentView?
    
    private func createNodeFromXML(id : Int, type : P_NODE_TYPE, position : CGPoint, text : String?) {
        if self.targetView == nil {
            print("Target View doesn't exist.")
            return
        }
        else {
            switch (type) {
            case .TEXT:
                let textnode = PTextNode(id: id, position: position, text: text!)
                self.targetView?.PAddNode(target: textnode)
            case .CRAWLING:
                let crawlingnode = PCrawlingNode(id: id, position: position)
                self.targetView?.PAddNode(target: crawlingnode)
            case .ERROR:
                print("File Error.")
            }
        }
    }
    
    private func createLinkFromXML(node_1 : Int, node_2 : Int) {
        if self.targetView == nil {
            print("Target View doesn't exist.")
            return
        }
        else {
            self.targetView?.createLinkByID(id_1: node_1, id_2: node_2)
        }
    }
    
    
    func load(view : PCustomDocumentView, filepath : URL) {
        view.initViewItem()
        
        
    }
    
}





