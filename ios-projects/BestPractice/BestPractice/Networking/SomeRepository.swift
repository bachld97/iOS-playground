class SomeRepository {

    private let ws: URLSessionWebService
    
    init(ws: URLSessionWebService) {
        self.ws = ws
    }
    
    func loadUser() {
        let request = HTTPRequest.demo
        ws.handleRequest(request) { (result: Result<DecodableString, Error>) in

        }
    }
}
