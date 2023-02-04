import Foundation

struct ControlFactory {
    static func button(title: String?=nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .black
        return button
    }
    
    static func label(textStyle: UIFont.TextStyle, multiline: Bool=false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = CommonColor.lightText
        label.numberOfLines = multiline ? 0 : 1
        return label
    }
}
