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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FrigadeProvider.load(flowId: "flow_NP2Petdcsjxq613V") { result in
            switch result {
            case .success(let flow):
                flow.delegate = self
                flow.present(overViewController: self)
            case .failure(let error):
                NSLog("Error loading flow. Reason: \(error.localizedDescription)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: FrigadeFlowDelegate {
}
