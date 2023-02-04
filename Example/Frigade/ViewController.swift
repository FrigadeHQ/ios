import UIKit
import Frigade

class ViewController: UIViewController {
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
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowStarted")
    }
    
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowCompleted")
    }
    
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowAborted")
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, startedStep id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:startedStep '\(id)'")
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, completedStep id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:completedStep '\(id)'")
    }
}
