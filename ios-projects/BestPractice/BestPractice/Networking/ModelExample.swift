import Foundation

struct API_User: Decodable {
    private lazy var id: String  = {
        return _id?.stringValue ?? "Default value" // This makes no sense by the way
    }()
  
    private lazy var name: String = {
        return _name ?? "Default value"
    }()

    private lazy var email: String = {
        if _email == nil {
            codingKeysThatFails.append(CodingKeys._email)
            return "Default value"
        }
        
        return _email ?? "Default value"
    }()
  
    private let _id: DecodableString?
    private let _name: String?
    private let _email: String?
  
    mutating func domainUser() -> User {
      return User(id: id, name: name, email: email)
    }
  
    var isResponseFullyParsable: Bool {
        return _id != nil && _name != nil && _email != nil
    }
    
    var codingKeysThatFails: [CodingKey] = []
    
    static var testCodingKey: CodingKey = CodingKeys._id
  
    private enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _name = "name"
        case _email = "email"
    }
}

// For domain usage
struct User: Identifiable {
    typealias ID = String
    
    var id: ID
    let name: String
    let email: String
}
