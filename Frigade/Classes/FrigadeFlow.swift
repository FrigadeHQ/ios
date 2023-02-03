import Foundation

public protocol FrigadeFlowDelegate: AnyObject {
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow)
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow)
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow)
    func frigadeFlow(frigadeFlow: FrigadeFlow, startedStep id: String)
    func frigadeFlow(frigadeFlow: FrigadeFlow, completedStep id: String)
}

public class FrigadeFlow {
    public weak var delegate: FrigadeFlowDelegate?
    public let flowId: String
    private let data: [FlowModel]
    private var didTapPrimaryButton = false
    
    init(flowId: String, data: [FlowModel]) {
        self.flowId = flowId
        self.data = data
    }
    
    public func present(overViewController viewController: UIViewController) {
        let swiperFlowVc = SwiperFlowViewController(data: data)
        swiperFlowVc.delegate = self
        swiperFlowVc.presentingFlow = self
        viewController.present(swiperFlowVc, animated: true, completion: {self.delegate?.frigadeFlowStarted(frigadeFlow: self)})
    }
}

extension FrigadeFlow: SwiperFlowViewControllerDelegate {
    func swiperFlowViewController(viewController: SwiperFlowViewController, didShowModel model: FlowModel) {
        
    }
    
    func swiperFlowViewController(viewController: SwiperFlowViewController, onPrimaryButtonForModel model: FlowModel) {
        didTapPrimaryButton = true
        viewController.dismiss(animated: true)
    }
    
    func swiperFlowViewControllerOnDismiss(viewController: SwiperFlowViewController) {
        if didTapPrimaryButton {
            delegate?.frigadeFlowCompleted(frigadeFlow: self)
        } else {
            delegate?.frigadeFlowAborted(frigadeFlow: self)
        }
    }
}
