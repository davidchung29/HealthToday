//
//  getFipsData.swift
//  Clima
//
//  Created by David Jr on 12/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
struct getFipsData: Decodable{
    let results: [Results]
}
struct Results:Decodable{
    let county_fips: String
}
