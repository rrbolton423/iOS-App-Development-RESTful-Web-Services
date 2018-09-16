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
            newMusic.saveToServer()
//            if let musicData = try? JSONEncoder().encode(newMusic) {
//                print (musicData)
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

