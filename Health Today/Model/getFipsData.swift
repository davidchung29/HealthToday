//
//  getFipsData.swift
//
//  Created by David Jr on 12/5/20.
//

import Foundation
struct getFipsData: Decodable{
    let results: [Results]
}
struct Results:Decodable{
    let county_fips: String
}
