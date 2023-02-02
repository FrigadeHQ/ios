
class BasicContentViewController: UIViewController {
    var data: FlowModel? {
        didSet {
            titleLabel.text = data?.title
            titleLabel.textAlignment = NSTextAlignment(from: data?.titleStyle?.textAlign)
            subtitleLabel.text = data?.subtitle
            if let primaryButtonTitle = data?.primaryButtonTitle {
                primaryButton.setTitle(primaryButtonTitle, for: .normal)
            }
            primaryButton.isHidden = (data?.primaryButtonTitle == nil)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = CommonColor.lightText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = CommonColor.lightText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, UIView(), primaryButton])
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

struct CommonColor {
    static let darkBackground = UIColor(red: 5/255.0, green: 0, blue: 40/255.0, alpha: 1)
    static let lightText = UIColor(red: 22/255.0, green: 163/255.0, blue: 249/255.0, alpha: 1)
}
