//
//  JSONResponseDecoder.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()

    public init() { }

    public func decode<T: Decodable>(_ data: Data) throws -> T {
      return try jsonDecoder.decode(T.self, from: data)
    }
}
