//
//  ViewController.swift
//  RESTful
//
//  Created by Bear Cahill on 2/12/18.
//  Copyright © 2018 Bear Cahill. All rights reserved.
//

import UIKit

let DomainURL = "https://www.orangevalleycaa.org/api/"

class Music : Codable {
    
    var guid : String?
    var music_url : String?
    var name : String?
    var description : String?
    
    enum CodingKeys : String, CodingKey {
        case guid = "id"
        case music_url, name, description
    }
    
    required init(from encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let serverGUID = guid?.replacingOccurrences(of: "id:", with: "")
        try container.encode(serverGUID, forKey: .guid)
        try container.encode(name, forKey: .name)
        // and the rest
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let val = try values.decode(String.self, forKey: .guid)
        guid = "id:\(val)"
        name = try values.decode(String.self, forKey: .name)
        // rest of the properties
    }
    
    static func fetch(withID id : Int, completionHandler: @escaping (Music)->Void) {
        let urlString = DomainURL + "music/id/\(id)"
        
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
                if let newMusic = try? JSONDecoder().decode(Music.self, from: data!) {
                    print (newMusic.guid ?? "no guid")
                    print (newMusic.music_url ?? "no url")
                    completionHandler(newMusic)
                }
            })
            task.resume()
        }
    }
    
    func saveToServer() {
        let urlString = DomainURL + "music/"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "POST"
        req.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }

    func updateServer() {
        guard self.guid != nil else { return }
        let urlString = DomainURL + "music/id/\(self.guid!)"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "PUT"
        req.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }

    func deleteFromServer() {
        guard self.guid != nil else { return }
        let urlString = DomainURL + "music/id/\(self.guid!)"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Music.fetch(withID: 1) { (newMusic) in
            print (newMusic.music_url ?? "no url")
            newMusic.description = "new description"
//            newMusic.updateServer()
//            newMusic.deleteFromServer()
              if let musicData = try? JSONEncoder().encode(newMusic) {
                  print (musicData)
              }
         }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

