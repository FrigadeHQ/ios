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
        assert(!data.isEmpty)
        self.flowId = flowId
        self.data = data
    }
    
    public func present(overViewController viewController: UIViewController) {
        let swiperFlowVc = SwiperFlowViewController(data: data)
        swiperFlowVc.delegate = self
        swiperFlowVc.presentingFlow = self
        viewController.present(swiperFlowVc, animated: true, completion: {self.delegate?.frigadeFlowStarted(frigadeFlow: self)})
        emitFlowResponse(flowModel: data.first!, actionType: .startedFlow)
    }
    
    private func emitFlowResponse(flowModel: FlowModel, actionType: FlowResponsesModel.ActionType) {
        let content = FlowResponsesModel(foreignUserId: FrigadeProvider.config?.userId,
                                         flowSlug: flowId,
                                         stepId: flowModel.id,
                                         actionType: actionType,
                                         data: "{}")
        FrigadeAPI.flowResponses(content: content).sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                NSLog("Error: \(error.localizedDescription)")
            }
        }, receiveValue: { _ in
        }).store(in: &FrigadeAPI.requests)
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
            emitFlowResponse(flowModel: data.first!, actionType: .completedFlow)
        } else {
            delegate?.frigadeFlowAborted(frigadeFlow: self)
            emitFlowResponse(flowModel: data.first!, actionType: .abortedFlow)
        }
    }
}
