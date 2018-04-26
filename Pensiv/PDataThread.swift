//
//  PDataThread.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 12..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa

class PDataThread
{
    static let pInstance = PDataThread()
    
    var thread : Thread?
    var superview : PCustomDocumentView?
    
    let dataManager = Neo4jWrapper()
    
    func initWrapper() {
        self.dataManager.initWrapper()
    }
    
    func connect() -> Bool {
        return self.dataManager.connect()
    }
    
    func disconnect() {
        self.dataManager.disconnect()
    }
    
    
    private init() {
        print("Singleton Thread is created.")
    }
    
    deinit {
        dataManager.disconnect()
    }
    
    ///////////////////////////////////////////////////////////////////////////
    var parent : PNode?
    var maps : Array<PTextItem>?
    
    private func getTextsByDepth(depth : Int) -> Array<String> {
        var arr = Array<String>()
        
        for item in self.maps! {
            let text_arr = item.getTextsByDepth(depth: depth)
            
            arr.append(contentsOf: text_arr)
        }
        
        return arr
    }
    
    
    private func getTextItemsByDepth(depth : Int) -> Array<PTextItem> {
        var arr = Array<PTextItem>()
        
        for item in self.maps! {
            let text_arr = item.getTextItemsByDepth(depth: depth)
            
            arr.append(contentsOf: text_arr)
        }
        
        return arr
    }
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    func getRelatedTextsAndCounts(str_1 : String, str_2 : String) -> Array<(String, Int)> {
        var arr = Array<(String,Int)>()
        
        let query = """
                    match p=(a)-[*2..5]-(b) where a.Name="\(str_1)" AND b.Name="\(str_2)"
                    with nodes(p) as nds limit 40
                    unwind nds as nd
                    with nd.Name as n, count(nd) as c
                    return n,c order by c DESC
                    """
        
        
        if dataManager.runQuery(query) == true {
            while dataManager.fetchNext() == true {
                if let str = dataManager.fetchString() {
                    let count = dataManager.fetchCount()
                    if (str == str_1) || (str == str_2) {
                        continue
                    }
                    
                    arr.append((str, Int(count)))
                }
                
            }
        }
        

        return arr
    }
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    var relatedMap = Array<PTextItem>()
    
    
    private func createFirstArr() -> Array<(String, Int)> {
        var related_arr = Array<(String, Int)>()
        
        let first_arr = self.getTextItemsByDepth(depth: 0)
        switch first_arr.count {
        case 2:
            let arr = self.getRelatedTextsAndCounts(str_1: first_arr[0].text, str_2: first_arr[1].text)
            related_arr.append(contentsOf: arr)
            
        case 3:
            let arr_1 = self.getRelatedTextsAndCounts(str_1: first_arr[0].text, str_2: first_arr[1].text)
            let arr_2 = self.getRelatedTextsAndCounts(str_1: first_arr[0].text, str_2: first_arr[2].text)
            let arr_3 = self.getRelatedTextsAndCounts(str_1: first_arr[1].text, str_2: first_arr[2].text)
            related_arr.append(contentsOf: arr_1)
            related_arr.append(contentsOf: arr_2)
            related_arr.append(contentsOf: arr_3)
            
        default:
            print("Not Suitable arrCount")
        }
        
        //중복 제거
        var main_arr = Array<(String, Int)>()
        for tuple in related_arr {
            let duplicated = main_arr.contains{ element in
                if element.0 == tuple.0 {
                    return true
                }
                else {
                    return false
                }
            }
            if duplicated == false {
                main_arr.append(tuple)
            }
        }
        
        //참조 횟수 순 정렬
        main_arr.sort { $0.1 > $1.1 }
        
        return main_arr
    }
    
    
    
    private func createRelatedMap() {
        //첫 목록 생성
        //0깊이 배열을 생성 후, 참조횟수 순으로 메인노드 생성
        var main_arr = self.createFirstArr()
        
        
        //main_arr을 관계 개수에 따른 비율을 토대로 맵 형성
        var count = 0
        for tuple in main_arr {
            count += tuple.1
        }
        
        print(main_arr)
        print(main_arr.count)
        print(count)
        
        
        
        
        
        //self.superview?.createNodeFromMap(parent: self.parent!, map: self.relatedMap)
        
    }
    
    
    
    func startThread(parent : PNode, maps : Array<PTextItem>) {
        self.parent = parent
        self.maps = maps
        
        
        //let thread = Thread(target: self, selector: Selector("run"), object: nil)
        //thread.start()
        //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
        
        
        //var nodes = self.createNodeFromArray(depth: 0, width: 300, parent: self.parent!, arr: arr)
        self.createRelatedMap()
    }
}






