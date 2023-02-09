
public struct DataArrayResponse<T:Codable>: Codable {
    let data: [T]
}

public struct FlowModel: Codable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let primaryButtonTitle: String?
    public let titleStyle: TitleStyleModel?
    public let imageUri: URL?
    public let type: String?
}

public struct TitleStyleModel: Codable {
    public let textAlign: String?
}

// TODO: surely there is a better pattern, but this works for now
extension NSTextAlignment {
    init?(from string: String?) {
        switch string {
        case .some("center"):
            self = .center
        default:
            return nil
        }
        
    }
}

public struct FlowResponsesModel: Codable {
    public enum ActionType: String, Codable {
        case startedFlow = "STARTED_FLOW"
        case completedFlow = "COMPLETED_FLOW"
        case abortedFlow = "ABORTED_FLOW"
        case startedStep = "STARTED_STEP"
        case completedStep = "COMPLETED_STEP"
    }
    public let foreignUserId: String?
    public let flowSlug: String
    public let stepId: String?
    public let actionType: ActionType
    public let data: String
}

// TODO: check with christian what he calls this on backend
struct FlowResponsesStatusModel: Codable {
}
