//
//  LogoutSuccessResponse.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/05.
//

import Foundation

struct LogoutSuccessResponse: Decodable {
    let message: String
    let code: String
    let status: Int
}
