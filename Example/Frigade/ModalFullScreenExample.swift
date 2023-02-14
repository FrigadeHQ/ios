import UIKit
import Frigade

class ModalFullScreenExample: UIViewController {
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Load flow", for: .normal)
        button.addTarget(self, action: #selector(onLoadFlow), for: .touchUpInside)
        
        view.addSubview(button)
        button.frame = CGRect(x: view.center.x-128, y: 256, width: 256, height: 48)
        button.backgroundColor = .black
        button.layer.cornerRadius = 24
    }
    
    @objc func onLoadFlow() {
        button.setTitle("Loading...", for: .normal)
        button.isUserInteractionEnabled = false
        
        FrigadeProvider.load(flowId: "flow_NP2Petdcsjxq613V") { result in
            switch result {
            case .success(let flow):
                flow.delegate = self
                flow.present(overViewController: self, presentationStyle: .fullScreen, animated: false)
            case .failure(let error):
                NSLog("Error loading flow. Reason: \(error.localizedDescription)")
            }
            
            self.button.setTitle("Load flow", for: .normal)
            self.button.isUserInteractionEnabled = true
        }
    }
}


extension ModalFullScreenExample: FrigadeFlowDelegate {
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
