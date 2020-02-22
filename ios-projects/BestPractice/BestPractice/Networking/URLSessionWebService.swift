import Foundation

class URLSessionWebService {
    typealias Request = HTTPRequest
    typealias Handler<T> = (Result<T, Error>) -> Void
    typealias Return = URLSessionTask?
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    @discardableResult
    func handleRequest<T: Decodable>(
        _ request: Request,
        handler: Handler<T>?
    ) -> Return {
        guard let urlRequest = request.urlRequest else {
            handler?(.failure(APIError.cannotEncodeRequest))
            return nil
        }

        let onResult: (Data?, URLResponse?, Error?) -> Void = { data, _, error in
            if let error = error {
                handler?(.failure(error))
                return
            }
            
            guard let data = data else {
                handler?(.failure(APIError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                handler?(.success(result))
            } catch {
                handler?(.failure(error))
            }
        }
        
        
        let task = urlSession.dataTask(with: urlRequest, completionHandler: onResult)
        task.resume()
        return task
    }
}

struct HTTPRequest {
    let scheme: URLScheme
    let domain: String
    let path: String
    let httpMethod: HttpMethod
    let params: [String: String]?
    let cookies: String?
    
    var urlRequest: URLRequest? {
        guard let url = encodedUrl else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let cookies = cookies {
            request.httpShouldHandleCookies = true
            request.setValue(cookies, forHTTPHeaderField: "Cookie")
        }
        return request
    }
    
    private var encodedUrl: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = domain
        components.path = path
        components.queryItems = params?.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
    
    enum URLScheme: String {
        case http = "http"
        case https = "https"
    }
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    static var demo: HTTPRequest {
        return .init(
            scheme: .https, domain: "google.com", path: "search",
            httpMethod: .get,
            params: ["q": "something"],
            cookies: nil
        )
    }
}
