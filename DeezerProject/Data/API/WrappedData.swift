//
//  ApiResponseWrappedData.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation

struct WrappedData<T: Decodable>: Decodable {
    let data: T
}
