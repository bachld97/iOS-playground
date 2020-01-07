//
//  DecodableString.swift
//  BestPractice
//
//  Created by Bach Le on 1/7/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation

class DecodableString: Hashable, Comparable, Equatable, Decodable {
    static func < (lhs: DecodableString, rhs: DecodableString) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
    
    static func == (lhs: DecodableString, rhs: DecodableString) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    
    func hash(into hasher: inout Hasher) {
        return stringValue.hash(into: &hasher)
    }
    
    let stringValue: String
    
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

enum ApiError: Error {
    case cannotDecodeData(codingKey: CodingKey?)
}


struct User: Identifiable, Decodable {
    typealias ID = DecodableString
    
    var id: ID
    let name: String
    let email: String
}
