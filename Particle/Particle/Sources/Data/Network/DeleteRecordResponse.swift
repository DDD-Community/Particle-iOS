//
//  DeleteRecordResponse.swift
//  Particle
//
//  Created by 이원빈 on 2023/11/06.
//

import Foundation

struct DeleteRecordResponse: Decodable {
    let message: String
    let status: Int
    let code: String
}
