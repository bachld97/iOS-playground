# Decodable

Weather, emails, social media updates, ... 

Information is ubiquitous in the age of technology, and our mobile devices are an innovative ways to spread data. Most of our mobile applications nowadays are connected to at least one Backend Server. This can be as a mean process data and synchronize them accross your personal devices (Evernote, OneNote, Google Keep, etc.), or this can serve as a mean to connect people (think Email, Facebook, Youtube, etc.).

As an iOS developers, we have to deal with the response from our Backend Servers using Apple's SDK for iPhones and iPads. Most of the time, this information is given to us in the form of JSON objects (JavaScript Object Notation).

To decode JSON data, there are a tedious way, an okay way, and an easy way. Let's walk through each of the methods that can be used to parse JSON.

## Treat JSON as \[String : Any\]

Any JSON object has keys and values, therefore we almost instantly think of treating it as a dictionary. To parse `JSON` as dictionary, we use `JsonSerialization` class.

```swift
let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String : Any]
```

However, this is a tedious way to parse JSON as it maybe deeply nested and/or contain multiple shallowly nested data. Next, we will take a look at how we can use `Decodable` class to parse JSON

## Simple Decodable

There are multiple tutorials and documentation about `Decodable` and how to use it online. I will simply summary how to use it, the problem I face while using `Decodable` then the next part will reveal how I solve such problem.

Simply speaking, `Decodable` protocol is a built in way to help us parse structured data more easily. To parse response from our Backend Server, we define an object fitting the JSON description.

For example, the JSON from our server is as follow

```json
{ // Data for a user
  	"id": 1,
  	"name": "Bach Le",
  	"email": "ldbach97@gmail.com"
}
```

The corresponding struct/class to parse data maybe as follow

```swift
struct User: Identifiable, Decodable {
    typealias ID = Int64
    
    var id: ID
    let name: String
    let email: String
}
```

Then parse the data, we use a `JSONDecoder`

```swift
let jsonData = ..... // Extract Data object from API response

let decoder = JSONDecoder()
let user = try? decoder.decode(User.self, from: jsonData) // User is optional here
```

So far so good?

Not quite.

As you can see, the property `id` is of type `Int64`. Which means it will fail to parse if our backend server acidentally returns ` { "id": "123" }` instead of `{ "id": 123 }` (Plus there is a greate chance where they consider `Integer` to be terible identifier and switch to `String` altogether. We do not want such change to affect our client code.

### Better Decodable

As you can see, the problem lies in the type of our `User::id`... You maybe tempted to change the type of our user's ID to `String` and be done with it. Like this:

```swift
struct User: Identifiable, Decodable {
    typealias ID = String
    
    var id: ID
    let name: String
    let email: String
}
```

But sadly, this cannot parse the original JSON data above...

So the problem becomes how to define an object that can be used to parse `Number` and `String` (or `Bool` if you need to, but I do not know why you would want that) while keeping the convenience of `Decodable` interface.

I have tried and failed a few times, most of the previous time my solution would not be fully compatible with `Decodable` or it is too complicated to use. Most of those issues are because I tried to implement it in existing codebase where my IDs are `String`. As a result, I wrote complicated generic wrapper around the data class and do crazy stuff, only to realize it cannot be used with objects which are nested or in an array. I avoided create a new String class because I think it would be tedious to replace code in multiple places. However, I try creating a new `String` wrapper class and use it as replacement for `String`, and the solution comes easily.

```swift
class DecodableString: Hashable, Comparable, Equatable, Decodable {
    // Sorting ID is a common functionality
    static func < (lhs: DecodableString, rhs: DecodableString) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
    
    // Comparing ID is also a common functinality
    static func == (lhs: DecodableString, rhs: DecodableString) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    
    // We want to use it with Identifiable, so it must conform to hashable
    func hash(into hasher: inout Hasher) {
        return stringValue.hash(into: &hasher)
    }
  
    let stringValue: String
    
  	// Constructor to create assert object when unit testing
    init(string: String) {
        self.stringValue = string
    }
    
    required init(from decoder: Decoder) throws {
        var result: String?
       
        // Decoding order: UInt64, Int64, Double, String
        result = try? "\(decoder.singleValueContainer().decode(UInt64.self))"
        result = result ?? (try? "\(decoder.singleValueContainer().decode(Int64.self))")
        result = result ?? (try? "\(decoder.singleValueContainer().decode(Double.self))")
        result = result ?? (try? "\(decoder.singleValueContainer().decode(String.self))")
        
        if let result = result {
            stringValue = result
        } else {
            let lastCodingKey = decoder.codingPath.last
            throw ApiError.cannotDecodeData(codingKey: lastCodingKey)
        }
    }
}
```

And to use it as drop in replacement for our User class

```swift
struct User: Identifiable, Decodable {
    typealias ID = DecodableString
    
    var id: ID
    let name: String
    let email: String
}
```

When we implement `required init(from decoder: Decoder)`, we instruct the decoder to parse current data into our object. In my `DecodableString` class, this function tells the decoder to sequentially treat this data as `UInt64`, `Int64`, `Double`, then as `String`. If the bytes can be parsed into one of the above type, we convert it to `String` and assign it into our internal `String` object. Otherwise, we raise an error together with the `CodingKey` that are failed to be parsed.

Next, I will show the unit test class to parse data using `DecodableString`. In each test case, I also include a similar model class but use `String` instead of `DecodableString` (and asset `String`-using struct to be `nil`.

```swift
class DecodableStringTests: XCTestCase {

    func testCanDecodeUInt64AsDecodableString() {
        let data = """
        {
            "string": \(UINT64_MAX)
        }
        """.data(using: .utf8)!
        
        let stringFromUInt = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
        let nilParseResult = try? JSONDecoder().decode(ModelNotDecodable.self , from: data)

        XCTAssertNil(nilParseResult)
        XCTAssertEqual(stringFromUInt, "\(UINT64_MAX)")
    }
    
    func testCanDecodeNegativeInt64AsDecodableString() {
           let data = """
           {
               "string": -123123
           }
           """.data(using: .utf8)!
           
           let stringFromInt = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
           let nilParseResult = try? JSONDecoder().decode(ModelNotDecodable.self , from: data)

           XCTAssertNil(nilParseResult)
           XCTAssertEqual(stringFromInt, "-123123")
       }

    func testCanDecodeDoubleAsDecodableString() {
        let data = """
        {
            "string": -123.2345
        }
        """.data(using: .utf8)!
        
        let stringFromDouble = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
        let nilParseResult = try? JSONDecoder().decode(ModelNotDecodable.self , from: data)
        
        XCTAssertNil(nilParseResult)
        XCTAssertEqual(stringFromDouble, "-123.2345")
    }
    
    func testCanDecodeStringAsDecodableString() {
        let data = """
        {
            "string": "trivial case"
        }
        """.data(using: .utf8)!
        
        let stringFromString = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
        XCTAssertEqual(stringFromString, "trivial case")
    }
    
    class ModelDecodable: Decodable {
        let string: DecodableString
        
        var stringValue: String {
            return string.stringValue
        }
    }
    
    class ModelNotDecodable: Decodable {
        let string: String
    }
}
```

You can take a look at the `BestPractice/` folder, navigate to `BestPractice/BestPracticeUnitTests/DecodableString/` to run test cases related to this article.

Thanks for your time. Enjoy your coding journey. Peace.
