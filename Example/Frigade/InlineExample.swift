import UIKit
import Frigade

class InlineExample: UIViewController {
    let button = UIButton()
    let container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Inline", for: .normal)
        button.addTarget(self, action: #selector(onLoadFlow), for: .touchUpInside)
        
        view.addSubview(button)
        button.frame = CGRect(x: view.center.x-128, y: 256, width: 256, height: 48)
        button.backgroundColor = .black
        button.layer.cornerRadius = 24
        
        container.backgroundColor = .gray
        view.addSubview(container)
        container.frame = CGRectMake(24, 320, view.frame.width-48, view.frame.height-400).insetBy(dx: 8, dy: 8)
    }
    
    @objc func onLoadFlow() {
        button.setTitle("Loading...", for: .normal)
        button.isUserInteractionEnabled = false
        
        FrigadeProvider.load(flowId: "flow_NP2Petdcsjxq613V") { result in
            switch result {
            case .success(let flow):
                flow.delegate = self
                self.addToContainer(viewController: flow.viewController)
            case .failure(let error):
                NSLog("Error loading flow. Reason: \(error.localizedDescription)")
            }
            
            self.button.setTitle("Inline", for: .normal)
            self.button.isUserInteractionEnabled = true
        }
    }
    
    private func addToContainer(viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = container.bounds
        container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func removeFromContainer(viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension InlineExample: FrigadeFlowDelegate {
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowStarted")
    }
    
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowCompleted")
        
        removeFromContainer(viewController: frigadeFlow.viewController)
    }
    
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow) {
        NSLog("[FrigadeFlowDelegate] frigadeFlowAborted")
        
        removeFromContainer(viewController: frigadeFlow.viewController)
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepStarted id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:stepStarted '\(id)'")
    }
    
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepCompleted id: String) {
        NSLog("[FrigadeFlowDelegate] frigadeFlow:stepCompleted '\(id)'")
    }
}
