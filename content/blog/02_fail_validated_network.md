# Fail Validated Networking

In a few occasions, some of the field in JSON response from our Backend Server is missing, or invalid. When such events occur, the whole API request fails, rendering the current page with an empty space or ugly error message prompting to reload. As client-side engineer, we should be safe guard our application against such anomaly and try not to interupt the flow of our users. Note that when we handle defects, we do not want to swallow the error. We will have to find a way to notify our Backend Engineers of the problem. If the Backend Server deliver errornous data, telling them details on which field of the response causes the error would accelerate the debuging process.

To achieve this behavior, we need to separate API logic away from domain logic and add validation mechanism to our API model.

## API Model Separation

In the previous section, I have introduced a better way to parse string from API calls by introducing a wrapper to Decodable class. However, the solution introduced is not perfect (yet). Because the `DecodableString` class is only helpful as a way to decode a single key as `String`, it is not a good idea to introduce it to our entire codebase (because it is useless and increase boilerplate code when string operation on them is needed). 

As a result, we contain all usage `DecodableString` inside network model only. With this approach, we create two separate models. (I intentionally make the API model name ugly to discourage its use anywhere else.)

```swift
// For parsing API
struct API_User: Decodable {
    private let id: DecodableString
    private let name: String
    private let email: String
  
    var domainUser: User {
      return User(id: id.stringValue, name: name, email: email)
    }
}

// For domain usage
struct User: Identifiable {
    typealias ID = String
    
    var id: ID
    let name: String
    let email: String
}
```

With this approach, we can introduce `DecodableString` or any other decodable wrappers in API model without affecting the remaining codebase. One example is to create a validation for URL.

```swift
class URLDecodableString {
   required init(from decoder: Decoder) throws {
        var result: String?
        result = result ?? (try? "\(decoder.singleValueContainer().decode(String.self))")
        
        if let result = result, url = URL(string: result), url.scheme != nil, url.host != nil {
            stringValue = result
        } else {
            let lastCodingKey = decoder.codingPath.last
            throw ApiError.cannotDecodeData(codingKey: lastCodingKey)
        }
    }
}
```

## Fail Validated API Model

Now that we have separated the API model from our domain model, we can introduce default value and implement validation to notify our logging module that API responses fail.

For example, to introduce default value to our domain model, we can modify our API model as follows:

```swift
struct API_User: Decodable {
    private lazy var id: String  = {
        return _id?.stringValue ?? "Default value" // This makes no sense by the way
    }()
  
    private lazy var name: String = {
        return _name ?? "Default value"
    }()

    private lazy var email: String = {
        return _email ?? "Default value"
    }()
  
    private let _id: String
    private let _name: String
    private let _email: String
  
    // Because lazy var get initialized when we access it, this function has to be marked mutating.
    // If you choose to use struct instead of class, you can ignore this alteration.
    mutating func domainUser() -> User {
      return User(id: id.stringValue, name: name, email: email)
    }
  
    var isResponseFullyParsable: Bool {
        return _id != nil && _name != nil && _email != nil
    }
  
    private enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _name = "name"
        case _email = "email"
    }
}
```

With this implementation, we can figure out which API fails partially, take log it, and then notify our Backend Engineers to diagnose the problem. However, we can do better. With the current implementation we can only log that the API call is failing, but no information about which particular key failed to parse. We can take a step further and do something like this.

```swift
struct API_User {
    // Similar for other variables
    private lazy var email: String {
        if _email == nil {
            codingKeysThatFail.append(CodingKeys._email) 
            return "Default Value"
        }
        return _email ?? "Default Value"
    }
  
    var codingKeysThatFail: [CodingKey] = []
  
    private lazy var name: String = {
        return _name ?? "Default value"
    }()
}
```

When we read the coding key, we can obtain its `stringValue`. When an API [partially] fails, we can send this information to our logger.

```Swift
// Example log
func performLog(_ data: API_User) {
    let apiLog = APILog(apiType: .personalFeed, failKeys: data.codingKeysThatFail)
    APILogger.shared.submitLog(apiLog)
}
```
