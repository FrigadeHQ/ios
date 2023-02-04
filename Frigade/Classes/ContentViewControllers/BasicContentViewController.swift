
class BasicContentViewController: UIViewController {
    var data: FlowModel? {
        didSet {
            titleLabel.text = data?.title
            titleLabel.textAlignment = NSTextAlignment(from: data?.titleStyle?.textAlign)
            subtitleLabel.text = data?.subtitle
        }
    }

    private lazy var titleLabel = ControlFactory.label(textStyle: .title1, multiline: true)
    private lazy var subtitleLabel: UILabel = ControlFactory.label(textStyle: .title2, multiline: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, UIView()])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

