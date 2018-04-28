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
    static let pInstance = PFileManager()
    
    private init() {
    
    }
    
    
    //let fileManager = FileManager()
    
    private func createNodeXML(node : PNode) -> String {
        let position = node.frame.origin
        let type = node.getType()
        var str = """
                  \t\t<node>
                  \t\t\t<id>\(node.getID())</id>
                  \t\t\t<xpos>\(position.x)</xpos>
                  \t\t\t<ypos>\(position.y)</ypos>\n
                  """
        
        switch (type) {
        case .TEXT:
            let textnode = node as! PTextNode
            str.append("\t\t\t<type>TEXT</type>\n")
            str.append("\t\t\t<text>\(textnode.getText())</text>\n")
            
        case .CRAWLING:
            str.append("\t\t\t<type>CRAWLING</type>\n")
            
        case .ERROR:
            print("Node Type Error.")
        }
        
        str.append("\t\t</node>\n")
        
        return str
    }
    
    private func createLinkXML(node_1 : PNode, node_2 : PNode) -> String {
        let str = """
                  \t\t<link>
                  \t\t\t<node_1>\(node_1.getID())</node_1>
                  \t\t\t<node_2>\(node_2.getID())</node_2>
                  \t\t</link>\n
                  """
        
        return str
    }
    
    func save(filepath : URL, nodes : Set<PNode>, links : Set<PLink>) {
        var xml_str = """
                      <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
                      <CONTENTS>
                      \t<NODES>\n
                      """
        
        for node in nodes {
            let str = self.createNodeXML(node: node)
            xml_str.append(str)
        }
        
        let cover_1 = """
                      \t</NODES>

                      \t<LINKS>\n
                      """
        xml_str.append(cover_1)
        
        
        for link in links {
            let nodes = link.getNodes()
            let str = self.createLinkXML(node_1: nodes.0, node_2: nodes.1)
            xml_str.append(str)
        }
        
        let cover_2 = """
                      \t</LINKS>\n
                      </CONTENTS>\n
                      """
        xml_str.append(cover_2)
        
        
        //xml 확장자 파일로 변환
        do {
            try xml_str.write(to: filepath, atomically: false, encoding: .utf8)
            print("Save Completed.")
        }
        catch let error as NSError {
            print("Save Failed : \(error.localizedDescription)")
        }
        
    }
    
    
    
    var targetView : PCustomDocumentView?
    
    private func createNodeFromXML(id : Int, type : String, position : CGPoint, text : String?, delay : CFTimeInterval) {
        if self.targetView == nil {
            print("Target View doesn't exist.")
            return
        }
        else {
            switch (type) {
            case "TEXT":
                let textnode = PTextNode(id: id, position: position, text: text!, delay: delay)
                self.targetView?.PAddNode(target: textnode)
            case "CRAWLING":
                let crawlingnode = PCrawlingNode(id: id, position: position, delay: delay)
                self.targetView?.PAddNode(target: crawlingnode)
            default:
                print("Node Type Error.")
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
        
        self.targetView = view
        
        do {
            let xml = try XML(url: filepath, encoding: .utf8)
            
            let content = xml.at_css("CONTENTS")
            
            let nodes = content?.at_css("NODES")
            
            var delay = 0.0
            
            for node in (nodes?.css("node"))! {
                let id = Int((node.at_css("id")?.content)!)!
                let type = (node.at_css("type")?.content)!
                let xpos = Float((node.at_css("xpos")?.content)!)!
                let ypos = Float((node.at_css("ypos")?.content)!)!
                let text : String? = node.at_css("text")?.content
                
                self.createNodeFromXML(id: id, type: type, position: CGPoint(x: CGFloat(xpos), y: CGFloat(ypos)), text: text, delay: delay)
                
                
                delay += 0.2
            }
            
            
            let links = content?.at_css("LINKS")
            
            for link in (links?.css("link"))! {
                let node_1 = Int((link.at_css("node_1")?.content)!)!
                let node_2 = Int((link.at_css("node_2")?.content)!)!
                
                self.createLinkFromXML(node_1: node_1, node_2: node_2)
            }
            
        }
        catch let error as NSError {
            print("Load Failed : \(error.localizedDescription)")
        }
        
        
        self.targetView = nil
    }
    
}





