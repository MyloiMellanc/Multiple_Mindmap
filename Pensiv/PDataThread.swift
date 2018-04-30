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
                    match p=(a)-[*1..5]-(b) where a.Name="\(str_1)" AND b.Name="\(str_2)"
                    with nodes(p) as nds limit 20
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
    
    
    func getRelatedTextByDirection(str_1 : String, str_2 : String) -> String? {
        //let rand_num = arc4random() % 150000
        //skip \(rand_num)
        /*let query = """
                    match (a)-[*..1]-(target)-[*..4]-(b)
                    where a.Name="\(str_1)" AND b.Name="\(str_2)"
                    return target.Name limit 1
                    """
        */
        //이거 그냥 ShortestPath로 바꾸고, 길이 2이면 걍 패스하는 것로 하자
        
        let query = """
                    match p=shortestpath((a)-[*]-(b))
                    where a.Name="\(str_1)" AND b.Name="\(str_2)"
                    with nodes(p) as nds
                    unwind nds as nd
                    return nd.Name
                    """
        
        
        var result : String? = nil
        
        if dataManager.runQuery(query) == true {
            while dataManager.fetchNext() == true {
                if let str = dataManager.fetchString() {
                    if (str == str_1) || (str == str_2) {
                        continue
                    }
                    else {
                        print(str)
                        result = str
                    }
                }
            }
        }
        
        
        return result
    }
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    var relatedMap : Array<PTextItem>?
    var firstMapDepth = 0
    
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
    
    var firstArr = Array<(String, Int)>()
    
    let BASIC_MAP_NODES = 20
    
    private func connectPastAndCurrentItems(past : Array<PTextItem>, current : Array<PTextItem>) {
        var past_iterator = 0
        for item in current {
            past[past_iterator].addSubNode(target: item)
            past_iterator = (past_iterator + 1) % past.count
        }
        
    }
    
    private func createFirstRelatedMap() {
        //main_arr을 관계 개수에 따른 비율을 토대로 맵 형성
        var num = 0
        for tuple in self.firstArr {
            num += tuple.1
        }
        
        var average = num / self.firstArr.count
        var tier = 0
        
        var past_tier_textitems = Array<PTextItem>()
        
        while self.firstArr.isEmpty != true && tier < 3 {
            print("average : \(average)")
            
            print("Tier \(tier)")
            
            var tier_count = 0
            var index = 0
            
            var current_tier_textitems = Array<PTextItem>()
            for tuple in self.firstArr {
                print(tuple.0)
                
                let textitem = PTextItem(depth: tier, text: tuple.0)
                current_tier_textitems.append(textitem)
                
                tier_count += tuple.1
                index += 1
                
                if tier_count > average {
                    break
                }
            }
            
            if tier == 0 {
                self.relatedMap = current_tier_textitems
            }
            else {
                self.connectPastAndCurrentItems(past: past_tier_textitems, current: current_tier_textitems)
            }
            
            past_tier_textitems = current_tier_textitems
            
            self.firstArr.removeFirst(index)
            
            tier += 1
            
            average = tier_count
        }
    }
    
    private func modifyTextItems(target_arr : Array<PTextItem>, arr : Array<PTextItem>) {
        var target_index = 0
        var arr_index = 0
        
        while(arr_index < arr.count) {
            if let str = self.getRelatedTextByDirection(str_1: target_arr[target_index].text, str_2: arr[arr_index].text) {
                let item = target_arr[target_index]
                item.addSubNode(target: PTextItem(depth: item.depth + 1, text: str))
            }
            
            
            target_index = (target_index + 1) % target_arr.count
            arr_index += 1
        }
    }
    
    private func modifyFirstRelatedMap() {
        var map_max_depth = 0
        for item in self.maps! {
            let depth = item.getHighestDepth()
            if map_max_depth < depth {
                map_max_depth = depth
            }
        }
        
        var related_max_depth = 0
        for item in self.relatedMap! {
            let depth = item.getHighestDepth()
            if related_max_depth < depth {
                related_max_depth = depth
            }
        }
        
        
        if map_max_depth < 1 {
            return
        }
        else if map_max_depth < related_max_depth {
            var map_tier = 1
            var item_arr = Array<PTextItem>()
            
            for tier in 0...(related_max_depth - 1) {
                var target_arr = Array<PTextItem>()
                for item in self.relatedMap! {
                    let items = item.getTextItemsByDepth(depth: tier)
                    target_arr.append(contentsOf: items)
                }
                
                if map_tier <= map_max_depth {
                    item_arr = Array<PTextItem>()
                    for item in self.maps! {
                        let items = item.getTextItemsByDepth(depth: map_tier)
                        item_arr.append(contentsOf: items)
                    }
                }
                
                self.modifyTextItems(target_arr: target_arr, arr: item_arr)
                
                map_tier += 1
            }
        }
        else {
            for tier in 1...map_max_depth {
                var item_arr = Array<PTextItem>()
                for item in self.maps! {
                    let items = item.getTextItemsByDepth(depth: tier)
                    item_arr.append(contentsOf: items)
                }
                
                var target_arr = Array<PTextItem>()
                for item in self.relatedMap! {
                    let items = item.getTextItemsByDepth(depth: tier - 1)
                    target_arr.append(contentsOf: items)
                }
                
                self.modifyTextItems(target_arr: target_arr, arr: item_arr)
            }
        }
        
        
    }
    
    
    private func createRelatedMap() {
        //첫 목록 생성
        //0깊이 배열을 생성 후, 참조횟수 순으로 메인노드 생성
        self.firstArr = self.createFirstArr()
        if self.firstArr.isEmpty == true {
            return
        }
        
        while self.firstArr.count > self.BASIC_MAP_NODES {
            self.firstArr.removeLast()
        }
        
        print(self.firstArr)
        
        self.createFirstRelatedMap()
        
        self.modifyFirstRelatedMap()
        
        
        
        
        
        
        self.superview?.createNodeFromMap(parent: self.parent!, map: self.relatedMap!)
        
    }
    
    
    
    func startThread(parent : PNode, maps : Array<PTextItem>) {
        self.parent = parent
        self.maps = maps
        self.firstArr.removeAll()
        
        
        //let thread = Thread(target: self, selector: Selector("run"), object: nil)
        //thread.start()
        //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
        
        
        //var nodes = self.createNodeFromArray(depth: 0, width: 300, parent: self.parent!, arr: arr)
        self.createRelatedMap()
    }
}






