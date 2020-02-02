class DebugMessage {
    
    static func notifyUnexpectedFlowOfControl(crashInProduction: Bool = false) {
        let message = "Unexpected flow of control, review programming logic"
        if crashInProduction {
            fatalError(message)
        } else {
            assertionFailure(message)
        }
    }
    
}
