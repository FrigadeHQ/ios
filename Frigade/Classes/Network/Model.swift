
struct DataArrayResponse<T:Codable>: Codable {
    let data: [T]
}

struct FlowModel: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let primaryButtonTitle: String?
    let titleStyle: TitleStyleModel?
}

struct TitleStyleModel: Codable {
    let textAlign: String?
}

// TODO: surely there is a better pattern, but this works for now
extension NSTextAlignment {
    init(from string: String?) {
        switch string {
        case .some("center"):
            self = .center
        default:
            self = .natural
        }
        
    }
}
