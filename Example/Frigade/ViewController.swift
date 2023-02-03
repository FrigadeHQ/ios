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
    func frigadeFlow(frigadeFlow: FrigadeFlow, didTapPrimaryButtonOnFlowModel id: String) {
        NSLog("[FrigadeFlowDelegate] Primary Button tapped on page \(id)")
    }
    
    func frigadeFlowOnPresent(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] Flow \(frigadeFlow.flowId) presented")
    }
    
    func frigadeFlowOnDismiss(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] Flow \(frigadeFlow.flowId) dismissed")
    }
}
