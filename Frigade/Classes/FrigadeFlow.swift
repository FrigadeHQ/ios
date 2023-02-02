import Foundation

public protocol FrigadeFlowDelegate: AnyObject {
}

public class FrigadeFlow {
    public weak var delegate: FrigadeFlowDelegate?
    private let data: [FlowModel]
    
    init(data: [FlowModel]) {
        self.data = data
    }
    
    public func present(overViewController viewController: UIViewController) {
        let flowVC = SwiperFlowViewController(data: data)
        viewController.present(flowVC, animated: true, completion: nil)
    }
}

