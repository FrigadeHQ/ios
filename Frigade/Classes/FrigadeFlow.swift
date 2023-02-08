import Foundation
import Kingfisher
import Combine

public protocol FrigadeFlowDelegate: AnyObject {
    func frigadeFlowStarted(frigadeFlow: FrigadeFlow)
    func frigadeFlowCompleted(frigadeFlow: FrigadeFlow)
    func frigadeFlowAborted(frigadeFlow: FrigadeFlow)
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepStarted id: String)
    func frigadeFlow(frigadeFlow: FrigadeFlow, stepCompleted id: String)
}

public class FrigadeFlow {
    public weak var delegate: FrigadeFlowDelegate?
    public let flowId: String
    private let data: [FlowModel]
    private var isDismissingByPrimaryButton = false
    private var previousModelId: String?
    
    init(flowId: String, data: [FlowModel]) {
        assert(!data.isEmpty)
        self.flowId = flowId
        self.data = data
        
        // use kingfisher to prefetch images (BasicContentController should hit the cache then)
        let imageUris = data.compactMap({$0.imageUri})
        if !imageUris.isEmpty {
            ImagePrefetcher(urls: imageUris).start()
        }
    }
    
    public func getData() -> [FlowModel]  {
        return data
    }
    
    public func present(overViewController viewController: UIViewController, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        // FIXME: TODO: this is temporary hack to make things look OK for now, remove later
        ControlFactory.setupDefaultAppearance()
        
        let swiperFlowVc = SwiperFlowViewController(data: data)
        swiperFlowVc.modalPresentationStyle = presentationStyle
        swiperFlowVc.delegate = self
        swiperFlowVc.presentingFlow = self
        viewController.present(swiperFlowVc, animated: false, completion: {self.delegate?.frigadeFlowStarted(frigadeFlow: self)})
        emitFlowResponse(stepId: data.first?.id, actionType: .startedFlow)
    }
    
    public func getViewController() -> UIViewController {
        let swiperFlowVc = SwiperFlowViewController(data: data)
        swiperFlowVc.delegate = self
        swiperFlowVc.presentingFlow = self
        self.delegate?.frigadeFlowStarted(frigadeFlow: self)
        emitFlowResponse(stepId: data.first?.id, actionType: .startedFlow)
        return swiperFlowVc
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
            viewController.dismiss(animated: true)
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
    }
}
