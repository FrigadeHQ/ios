import Foundation
import Combine

public protocol FrigadeFlowDelegate: AnyObject {
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow)
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow)
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow)
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepStarted id: String)
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepCompleted id: String)
}

public class FrigadeFlow: NSObject {
    public let flowId: String
    public weak var delegate: FrigadeFlowDelegate?
    public var viewController: UIViewController { return flowViewController }
    
    private let data: [FlowModel]
    private var isDismissingByPrimaryButton = false
    private var previousModelId: String?
    private var flowViewController: SwiperFlowViewController
    
    init(flowId: String, data: [FlowModel]) {
        assert(!data.isEmpty)
        self.flowId = flowId
        self.data = data
        self.flowViewController = SwiperFlowViewController(data: data)
        super.init()
        
        flowViewController.presentingFlow = self
        flowViewController.delegate = self
    }

    public func present(overViewController viewController: UIViewController, presentationStyle: UIModalPresentationStyle, animated: Bool) {
        flowViewController.modalPresentationStyle = presentationStyle
        viewController.present(flowViewController, animated: animated, completion: nil)
    }
    
    private func emitFlowResponse(stepId: String?, actionType: FlowResponsesModel.ActionType) {
        let content = FlowResponsesModel(foreignUserId: FrigadeProvider.config?.userId,
                                         flowSlug: flowId,
                                         stepId: stepId,
                                         actionType: actionType,
                                         data: "{}")
        FrigadeAPI.flowResponses(content: content).subscribe(Subscribers.Sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    NSLog("Error: \(error.localizedDescription)")
                }
                
            },
            receiveValue: { _ in
            }
        ))
    }
}

extension FrigadeFlow: SwiperFlowViewControllerDelegate {
    func swiperFlowViewController(viewController: SwiperFlowViewController, didShowModel model: FlowModel) {
        if model.id != previousModelId {
            if let previousId = previousModelId {
                delegate?.frigadeFlow(frigadeFlow: self, stepCompleted: previousId)
                emitFlowResponse(stepId: previousId, actionType: .completedStep)
            }
            delegate?.frigadeFlow(frigadeFlow: self, stepStarted: model.id)
            emitFlowResponse(stepId: model.id, actionType: .startedStep)
            previousModelId = model.id
        }
    }
    
    func swiperFlowViewController(viewController: SwiperFlowViewController, didTapPrimaryButtonForModel model: FlowModel) {
        if model.id == data.last?.id {
            isDismissingByPrimaryButton = true
            if viewController.presentingViewController != nil {
                viewController.dismiss(animated: true)
            } else {
                self.swiperFlowViewControllerOnDismiss(viewController: viewController)
            }
        } else {
            viewController.advanceToNextPage()
        }
    }
    
    func swiperFlowViewControllerOnDismiss(viewController: SwiperFlowViewController) {
        if let previousId = previousModelId {
            delegate?.frigadeFlow(frigadeFlow: self, stepCompleted: previousId)
            emitFlowResponse(stepId: previousId, actionType: .completedStep)
        }
        
        if isDismissingByPrimaryButton {
            delegate?.frigadeFlowCompleted(frigadeFlow: self)
            emitFlowResponse(stepId: previousModelId, actionType: .completedFlow)
        } else {
            delegate?.frigadeFlowAborted(frigadeFlow: self)
            emitFlowResponse(stepId: previousModelId, actionType: .abortedFlow)
        }
        
        previousModelId = nil
        
        // break cycle so objects can be released
        flowViewController.presentingFlow = nil
    }
    
    func swiperFlowViewControllerDidAppear(viewController: SwiperFlowViewController) {
        emitFlowResponse(stepId: data.first?.id, actionType: .startedFlow)
        delegate?.frigadeFlowStarted(frigadeFlow: self)
    }
}
