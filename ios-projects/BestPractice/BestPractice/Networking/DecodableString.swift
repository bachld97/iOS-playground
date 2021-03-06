//
//  DecodableString.swift
//  BestPractice
//
//  Created by Bach Le on 1/7/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation

class DecodableString: Decodable {
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
        result = result ?? (try? decoder.singleValueContainer().decode(String.self))
       
        if let result = result {
            stringValue = result
        } else {
            // Throw Error
            stringValue = ""
        }
    }
}
