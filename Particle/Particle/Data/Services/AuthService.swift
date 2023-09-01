//
//  AuthService.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/30.
//

import Alamofire
import RxSwift

final class AuthService {
    
    func login(with body: LoginRequest) -> Observable<AFResult<LoginSuccessResponse>> {
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/auth/login")
        guard let url = urlComponent?.url else { return Observable.empty() }
        
        return Observable.create { emitter in
            let request = AF.request(
                url,
                method: .post,
                parameters: body.toDictionary(),
                encoding: JSONEncoding.default)
            
            request
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LoginSuccessResponse.self) { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            emitter.onNext(.success(data))
                        }
                        
                    case .failure(let error):
                        emitter.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
