import XCTest
import Foundation
@testable import BestPractice

class BestPracticeTests: XCTestCase {

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
           
           let stringFromUInt = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
           let nilParseResult = try? JSONDecoder().decode(ModelNotDecodable.self , from: data)

           XCTAssertNil(nilParseResult)
           XCTAssertEqual(stringFromUInt, "-123123")
       }

    func testCanDecodeDoubleAsDecodableString() {
        let data = """
        {
            "string": -123.2345
        }
        """.data(using: .utf8)!
        
        let stringFromUInt = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
        let nilParseResult = try? JSONDecoder().decode(ModelNotDecodable.self , from: data)
        
        XCTAssertNil(nilParseResult)
        XCTAssertEqual(stringFromUInt, "-123.2345")
    }
    
    func testCanDecodeStringAsDecodableString() {
        let data = """
        {
            "string": "trivial case"
        }
        """.data(using: .utf8)!
        
        let stringFromUInt = (try? JSONDecoder().decode(ModelDecodable.self , from: data))?.stringValue ?? ""
        XCTAssertEqual(stringFromUInt, "trivial case")
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
