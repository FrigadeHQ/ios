import UIKit
import Frigade

class ViewController: UIViewController {
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button.setTitle("Load flow", for: .normal)
        //button.addTarget(self, action: #selector(onLoadFlow), for: .touchUpInside)
        
        //view.addSubview(button)
        //button.frame = CGRect(x: view.center.x-128, y: 64, width: 256, height: 48)
        //button.backgroundColor = .black
        
        FrigadeProvider.load(flowId: "flow_NP2Petdcsjxq613V") { result in
            switch result {
            case .success(let flow):
                flow.delegate = self
                flow.present(overViewController: self)
                //let vc = flow.getViewController()
                //self.view.addSubview(vc.view)
            case .failure(let error):
                NSLog("Error loading flow. Reason: \(error.localizedDescription)")
            }
            
            self.button.setTitle("Load flow", for: .normal)
            self.button.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func onLoadFlow() {
        button.setTitle("Loading...", for: .normal)
        button.isUserInteractionEnabled = false
        
        FrigadeProvider.load(flowId: "flow_NP2Petdcsjxq613V") { result in
            switch result {
            case .success(let flow):
                flow.delegate = self
                flow.present(overViewController: self)
            case .failure(let error):
                NSLog("Error loading flow. Reason: \(error.localizedDescription)")
            }
            
            self.button.setTitle("Load flow", for: .normal)
            self.button.isUserInteractionEnabled = true
        }
    }
}


extension ViewController: FrigadeFlowDelegate {
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowStarted")
    }
    
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowCompleted")
    }
    
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowAborted")
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepStarted id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:stepStarted '\(id)'")
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepCompleted id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:stepCompleted '\(id)'")
    }
}
