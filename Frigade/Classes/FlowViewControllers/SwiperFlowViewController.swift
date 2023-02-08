import Foundation


protocol SwiperFlowViewControllerDelegate: AnyObject {
    func swiperFlowViewController(viewController: SwiperFlowViewController, didShowModel model: FlowModel)
    func swiperFlowViewController(viewController: SwiperFlowViewController, didTapPrimaryButtonForModel model: FlowModel)
    func swiperFlowViewControllerOnDismiss(viewController: SwiperFlowViewController)
}

class SwiperFlowViewController: UIViewController {
    let data: [FlowModel]
    weak var delegate: SwiperFlowViewControllerDelegate?
    
    // used to keep the owning flow alive until VC is dismissed/deallocated
    var presentingFlow: FrigadeFlow?
    
    private var viewControllers: [UIViewController] = []
    private var currentIndex = 0
    
    private lazy var contentController: UIPageViewController = {
        let contentController = UIPageViewController(transitionStyle: .scroll,
                                                     navigationOrientation: .horizontal,
                                                     options: [:])
        contentController.dataSource = self
        contentController.delegate = self
        return contentController
    }()
    
    private lazy var primaryButton: UIButton = {
        let button = ControlFactory.button()
        button.addTarget(self, action: #selector(onPrimaryButton), for: .touchUpInside)
        return button
    }()
    
    init(data: [FlowModel]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        assert(Set(data.map({$0.id})).count == self.data.count, "all IDs must be unique")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.swiperFlowViewController(viewController: self, didShowModel: data[currentIndex])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            delegate?.swiperFlowViewControllerOnDismiss(viewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addChild(contentController)
        contentController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        
        view.addSubview(primaryButton)
        
        NSLayoutConstraint.activate([
            contentController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentController.view.bottomAnchor.constraint(equalTo: primaryButton.topAnchor, constant: -8),
            
            primaryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        setupViewControllers()
        contentController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        updateCommonControls(with: data[0])
    }
    
    private func updateCommonControls(with model: FlowModel) {
        if (model.primaryButtonTitle == nil) {
            primaryButton.isHidden = true
        } else {
            primaryButton.isHidden = false
        }
        primaryButton.setTitle(model.primaryButtonTitle ?? Text.DefaultContinue, for: .normal)
    }
    
    private func setupViewControllers() {
        viewControllers = data.map({
            let vc = BasicContentViewController()
            vc.data = $0
            return vc
        })
    }
    
    private func viewController(forIndex index: Int) -> UIViewController? {
        assert(data.count == viewControllers.count)
        guard index >= 0 && index < data.count else {
            return nil
        }
        return viewControllers[index]
    }
    
    @objc private func onPrimaryButton() {
        let model = data[currentIndex]
        self.delegate?.swiperFlowViewController(viewController: self, didTapPrimaryButtonForModel: model)
    }
    
    public func advanceToNextPage() {
        guard let nextController = viewController(forIndex: currentIndex+1) else { return }
        currentIndex = currentIndex+1
        contentController.setViewControllers([nextController], direction: .forward, animated: true)
        updateCommonControls(with: data[currentIndex])
        delegate?.swiperFlowViewController(viewController: self, didShowModel: data[currentIndex])
    }
}

extension SwiperFlowViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        return self.viewController(forIndex: index-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        return self.viewController(forIndex: index+1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return data.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension SwiperFlowViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentController = contentController.viewControllers?.last {
            if let index = viewControllers.firstIndex(of: currentController) {
                currentIndex = index
                delegate?.swiperFlowViewController(viewController: self, didShowModel: data[currentIndex])
                updateCommonControls(with: data[currentIndex])
            } else {
                assert(false, "current viewcontroller now found in list of viewcontrollers, wtf")
            }
        }
    }
}
