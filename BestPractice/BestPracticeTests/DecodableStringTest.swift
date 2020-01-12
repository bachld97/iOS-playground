import XCTest
import Foundation
@testable import BestPractice

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
    
    func testCanDecodeStringWithDefaultValue() {
        let data = """
        {
            "stringMissing": "trivial case"
        }
        """.data(using: .utf8)!
        
        let stringFromNothing = try? JSONDecoder().decode(ModelDecodable.self , from: data).string
        XCTAssertNotNil(stringFromNothing)
        
        XCTAssertEqual(stringFromNothing!.stringValue, "")
        XCTAssertTrue(stringFromNothing!.isUsingDefaultValue)
    }
    
    
    class ModelDecodable: Decodable {
        let string: DecodableStringWithDefaultValue
        
        var stringValue: String {
            return string.stringValue
        }
    }
    
    class ModelNotDecodable: Decodable {
        let string: String
    }
}
