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

public class StringResponseDecoder: ResponseDecoder {
    
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if let responseString = String(data: data, encoding: .utf8) {
            return responseString as! T
        } else {
            throw DataTransferError.failToDecodeString
        }
    }
}

/// statusCode 만 통과되면 성공으로 판단하는 경우 사용
/// T 가 무조건 Bool 타입이어야 한다.
public class EmptyResponseDecoder: ResponseDecoder {
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if data.isEmpty {
            return true as! T
        } else {
            return false as! T
        }
    }
}
