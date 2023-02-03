import Foundation


protocol SwiperFlowViewControllerDelegate: AnyObject {
    func swiperFlowViewController(viewController: SwiperFlowViewController, didShowModel model: FlowModel)
    func swiperFlowViewController(viewController: SwiperFlowViewController, onPrimaryButtonForModel model: FlowModel)
    func swiperFlowViewControllerOnDismiss(viewController: SwiperFlowViewController)
}

class SwiperFlowViewController: UIViewController {
    let data: [FlowModel]
    weak var delegate: SwiperFlowViewControllerDelegate?
    
    // used to keep the owning flow alive until VC is dismissed/deallocated
    var presentingFlow: FrigadeFlow?
    
    private lazy var contentController: UIPageViewController = {
        let contentController = UIPageViewController(transitionStyle: .scroll,
                                                     navigationOrientation: .horizontal,
                                                     options: [:])
        contentController.dataSource = self
        contentController.delegate = self
        return contentController
    }()
    
    init(data: [FlowModel]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        assert(Set(data.map({$0.id})).count == self.data.count, "all IDs must be unique")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            delegate?.swiperFlowViewControllerOnDismiss(viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CommonColor.darkBackground
        
        addChild(contentController)
        contentController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            contentController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        contentController.setViewControllers([viewController(forIndex: 0)].compactMap({$0}), direction: .forward, animated: false, completion: nil)
    }
    
    private func viewController(forIndex index: Int) -> UIViewController? {
        guard index >= 0 && index < data.count else {
            return nil
        }
        let vc = BasicContentViewController()
        vc.data = data[index]
        vc.delegate = self
        return vc
    }
}

extension SwiperFlowViewController: ContentViewControllerDelegate {
    func contentViewControllerDidTapPrimaryButton(viewController: BasicContentViewController) {
        guard let data = viewController.data else { return }
        self.delegate?.swiperFlowViewController(viewController: self, onPrimaryButtonForModel: data)
    }
}

extension SwiperFlowViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentData = (viewController as? BasicContentViewController)?.data,
              let currentIndex = data.firstIndex(where: {$0.id == currentData.id}) else { return nil }
        return self.viewController(forIndex: currentIndex-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentData = (viewController as? BasicContentViewController)?.data,
              let currentIndex = data.firstIndex(where: {$0.id == currentData.id}) else { return nil }
        return self.viewController(forIndex: currentIndex+1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return data.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension SwiperFlowViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
}
