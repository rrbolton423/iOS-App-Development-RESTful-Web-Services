//
//  ViewController.swift
//  RESTful
//
//  Created by Bear Cahill on 2/12/18.
//  Copyright © 2018 Bear Cahill. All rights reserved.
//

import UIKit

let DomainURL = "https://www.orangevalleycaa.org/api/"

class Music {
    
    static func fetch(withID id: Int) {
        let urlString = DomainURL + "music/id/\(id)"
        
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
            })
            task.resume()
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Music.fetch(withID: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

