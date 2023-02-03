import Foundation

public protocol FrigadeFlowDelegate: AnyObject {
    func frigateFlow(frigadeFlow: FrigadeFlow, didTapPrimaryButtonOnFlowModel id: String)
    func frigateFlowOnPresent(frigadeFlow: FrigadeFlow)
    func frigateFlowOnDismiss(frigadeFlow: FrigadeFlow)
}

public class FrigadeFlow {
    public weak var delegate: FrigadeFlowDelegate?
    public let flowId: String
    private let data: [FlowModel]
    
    init(flowId: String, data: [FlowModel]) {
        self.flowId = flowId
        self.data = data
    }
    
    public func present(overViewController viewController: UIViewController) {
        let swiperFlowVc = SwiperFlowViewController(data: data)
        swiperFlowVc.delegate = self
        swiperFlowVc.presentingFlow = self
        viewController.present(swiperFlowVc, animated: true, completion: {self.delegate?.frigateFlowOnPresent(frigadeFlow: self)})
    }
}

extension FrigadeFlow: SwiperFlowViewControllerDelegate {
    func swiperFlowViewController(viewController: SwiperFlowViewController, onPrimaryButtonForModel model: FlowModel) {
        delegate?.frigateFlow(frigadeFlow: self, didTapPrimaryButtonOnFlowModel: model.id)
        viewController.dismiss(animated: true)
    }
    
    func swiperFlowViewControllerOnDismiss(viewController: SwiperFlowViewController) {
        delegate?.frigateFlowOnDismiss(frigadeFlow: self)
    }
}
