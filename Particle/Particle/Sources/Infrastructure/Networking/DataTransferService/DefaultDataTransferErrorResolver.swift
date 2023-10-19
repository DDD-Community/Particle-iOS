//
//  DefaultDataTransferErrorResolver.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() {}
    
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}
