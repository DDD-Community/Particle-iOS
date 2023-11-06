//
//  WithdrawResponse.swift
//  Particle
//
//  Created by 이원빈 on 2023/11/04.
//

import Foundation

struct WithdrawResponse: Decodable {
    let message: String
    let code: String
    let status: Int
}

//    {
//        "message": "withdrawal success",
//        "code": "WITHDRAWAL_SUCCESS",
//        "status": 200
//    }
