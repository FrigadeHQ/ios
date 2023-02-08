
struct DataArrayResponse<T:Codable>: Codable {
    let data: [T]
}

public struct FlowModel: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let primaryButtonTitle: String?
    let titleStyle: TitleStyleModel?
    let imageUri: URL?
}

struct TitleStyleModel: Codable {
    let textAlign: String?
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

struct FlowResponsesModel: Codable {
    enum ActionType: String, Codable {
        case startedFlow = "STARTED_FLOW"
        case completedFlow = "COMPLETED_FLOW"
        case abortedFlow = "ABORTED_FLOW"
        case startedStep = "STARTED_STEP"
        case completedStep = "COMPLETED_STEP"
    }
    let foreignUserId: String?
    let flowSlug: String
    let stepId: String?
    let actionType: ActionType
    let data: String
}

// TODO: check with christian what he calls this on backend
struct FlowResponsesStatusModel: Codable {
}
