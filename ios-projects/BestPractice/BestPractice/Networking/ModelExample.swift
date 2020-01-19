import Foundation

class API_User: Decodable {
    private let id: DecodableString
  
    private lazy var name: String = {
        if _name == nil {
            codingKeysThatFails.append(CodingKeys._name)
            return "bachld"
        }
        
        return _name!
    }()

    private lazy var email: String = {
        if _email == nil {
            codingKeysThatFails.append(CodingKeys._email)
            return "bachld@email.com"
        }
        
        return _email!
    }()
  
    private let _name: String?
    private let _email: String?
  
    var domainUser: User {
        return User(id: id.stringValue, name: name, email: email)
    }
  
    var isResponseFullyParsable: Bool {
        return _name != nil && _email != nil
    }
    
    var codingKeysThatFails: [CodingKey] = []
  
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case _name = "name"
        case _email = "email"
    }
}

// For domain usage
struct User: Identifiable, Equatable {
    typealias ID = String
    
    var id: ID
    let name: String
    let email: String
}
