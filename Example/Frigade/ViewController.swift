//
//  ViewController.swift
//  Frigade
//
//  Created by christianmat on 01/31/2023.
//  Copyright (c) 2023 christianmat. All rights reserved.
//

import UIKit
import Frigade

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let client = FrigadeClient(publicApiKey: "api_ANCKYIKTFN5A7VR14O5F1B9SNNZ0E5MZXPY4027PF717DKLR0JTSZ9RPXP1CVMXN")
        print(client.getPublicApiKey())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

