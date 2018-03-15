//
//  ViewController.swift
//  neo4jTest
//
//  Created by Myloi Mellanc on 2018. 3. 1..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Cocoa
import WebKit
import Theo
import CSV
import Kanna


class ViewController: NSViewController, WKNavigationDelegate {

    
    @IBOutlet var webView: WKWebView!

    
    var client : BoltClient? = nil
    
    func connectDatabase(host : String, portNumber : Int, user : String, password : String) throws {
        client = try BoltClient(hostname: host, port: portNumber, username: user, password: password, encrypted: true)
            
        client!.connect()
    }
    
    func createNewNodeInDatabase(text : String) throws {
        let node = Node(label: "Base", properties: ["Name" : text])
        
        let result = client!.createNodeSync(node: node)
        
        switch result {
        case let .failure(error):
            print(error.localizedDescription)
        default:
            break
        }
    }
    
    func mergeNewNodeInDatabase(text : String) {
        let cypher = "MERGE (:Base {Name : \(text)})"
        
        client!.executeCypher(cypher)
    }
    
    
    //http://terms.naver.com/search.nhn?query=    &searchType=&dicType=&subject=
    
    //https://www.google.co.kr/search?q=     &source=lnms&tbm=isch&sa=X&ved=0ahUKEwic-taB9IXVAhWDHpQKHXOjC14Q_AUIBigB&biw=1842&bih=990
    
    
    
    
    func createRelationInDatabase() {
        
    }
    
    
    
    func getRelatedWord(text : String) throws -> [String] {
        
        
        self.webView.navigationDelegate = self
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5"
        
        let url_base = "https://www.google.co.kr/search?q=퓨디파이&source=lnms&tbm=isch&sa=X&ved=0ahUKEwic-taB9IXVAhWDHpQKHXOjC14Q_AUIBigB&biw=1842&bih=990"
        
        let url_str = url_base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: url_str!)
        
        let req = URLRequest(url: url!)
        
        self.webView.load(req)
        
        
        
        
        var relatedList = [String]()
        /*
        for link_1 in doc.css("a")
        {
            if link_1["data-ident"] != nil
            {
                relatedList.append(link_1.content!)
            }
        }*/
        
        //구글 이미지 검색에서 1차 리스트 추출
        
        //1차 리스트 검증, 한글 확인, 네이버 지식백과 사용
        
        //검증에 통과된 항목들은 띄어쓰기 제거후 등록
        
        //2어절 이상인 항목들의 하위 단어를 등록
        
        return relatedList
    }

    
    
    
    
    
    var htmldata : String?
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
                                    self.htmldata = html as? String
                                    
                                    do {
                                        let doc = try HTML(html: self.htmldata!, encoding: .utf8)
                                        
                                        for link in doc.css("a")
                                        {
                                            if link["data-ident"] != nil {
                                                print(link.content!)
                                            }
                                        }
                                    } catch {
                                        print("web error")
                                    }
                                    
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        do {
            try self.connectDatabase(host: "localhost", portNumber: 7687, user: "neo4j", password: "flrndnqk23")
        }
        catch {
            print("Connection Error")
            return
        }
        */
        
        
        
        
        
        
        
        //연결없는 노드 10000개 찍어서 관계 형성
        
        
        /*
        
        let str2 = ["NNG.csv", "Wikipedia.csv"]
        let str1 =   ["Foreign.csv","Group.csv","IC.csv","NNB.csv","NNBC.csv","NNP.csv","NorthKorea.csv","NP.csv","NR.csv","Place-station.csv","XR.csv"]
        
        let str = ["Person-actor.csv","Person.csv","Place-address.csv","Place.csv"]
        
        let coinedWord = "CoinedWord.csv"
        
        let hanja = "Hanja.csv"
        
        
        do {
            let stream = InputStream(fileAtPath: hanja)
            let csv = try CSVReader(stream: stream!)
            
            var wordCount = 0
            
            
            while let row = csv.next() {
                let text : String = row[7]
                
                try self.createNewNodeInDatabase(text: text)
                wordCount = wordCount + 1
                
                if wordCount % 10000 == 0 {
                    print(wordCount)
                }
                
            }
            
            print("\(hanja) : \(wordCount)")
 
            
        }
        catch {
            print(11)
            return
        }
        */
        
        
        
        
        
        /*
        for i in 0...str.count-1 {
            do {
                let stream = InputStream(fileAtPath: str[i])
                let csv = try CSVReader(stream: stream!)
                
                var wordCount = 0
                
                print("Start Creating Node from \(str[i])")
                
                
                while let row = csv.next() {
                    let text : String = row[0]
                    
                    try self.createNewNodeInDatabase(text: text)
                    wordCount = wordCount + 1
                    
                    if wordCount % 10000 == 0 {
                        print(wordCount)
                    }
                }
         
                print("\(str[i]) : \(wordCount)")
            }
            catch {
                print("ERROR")
                return
            }
        }
        
        */
        
        
        
        /*
        let demowrapper = DemoWrapper()
        print(demowrapper.getInt())
        demowrapper.printDemo()
         */
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

}

