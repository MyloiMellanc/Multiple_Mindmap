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
        let url_base = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="
        
        let url = url_base + word
        
        let url_data = URL(string: url)
        
        let doc = try! HTML(url : url_data!, encoding : .utf8)
        
        print(doc.title! + "\n\n")
        
        
        for link_1 in doc.css("a")
        {
            if link_1["data-area"] != nil
            {
                print(link_1.content!)
            }
        }
        
    }
    
}




