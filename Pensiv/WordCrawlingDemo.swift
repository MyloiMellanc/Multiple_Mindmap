//
//  WordCrawlingDemo.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 16..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Kanna


class DemoWordCrawler
{
    init()
    {
        
    }
    
    deinit
    {
        
    }
    
    func makeRelatedWords(search word : String) -> [String]
    {
        let url_base = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="
        let url_str = (url_base + word).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: url_str!)
        let doc = try! HTML(url : url!, encoding : .utf8)
        
        var related_list = [String]()
        for link_1 in doc.css("a")
        {
            if link_1["data-area"] != nil
            {
                related_list.append(link_1.content!)
            }
        }
        
        return related_list
    }
    
    func demoRun()
    {
        
        let url = URL(string: "https:datalab.naver.com")
        let doc = try! HTML(url: url!, encoding: .utf8)
        
        print(doc.title!)
        
        for link in doc.css("div")
        {
            if link["class"] == "keyword_rank"
            {
                for link_2 in link.css("a")
                {
                    if (link_2["href"] == "#" && link_2["class"] == "list_area")
                    {
                        print((link_2.at_css("em")?.content)! + " : " + (link_2.at_css("span")?.content)!)
                        
                    }
                }
                print("-----------------")
            }
        }
        
    }
    
    
    func demoCrawling(search word : String)
    {
        let list_1 = makeRelatedWords(search: word)
        
        for words in list_1
        {
            print(words)
            let list_2 = makeRelatedWords(search: words)
            for words_2 in list_2
            {
                print(":: \(words_2)")
            }
        }
    }
    
}




