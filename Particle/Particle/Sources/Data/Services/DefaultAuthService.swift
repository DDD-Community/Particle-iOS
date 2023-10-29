//
//  DefaultAuthService.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/30.
//

import Alamofire
import RxSwift

final class DefaultAuthService: AuthService {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func login(with body: LoginRequest) -> RxSwift.Observable<LoginSuccessResponse> {
        let path = ParticleServer.Version.v1.rawValue
        + ParticleServer.Path.login.value
        
        let endpoint = Endpoint<LoginSuccessResponse>(
            path: path,
            method: .post,
            bodyParametersEncodable: body
        )
        
        return dataTransferService.request(with: endpoint)
    }
    
    
//    func login(with body: LoginRequest) -> Observable<AFResult<LoginSuccessResponse>> {
//        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/auth/login")
//        guard let url = urlComponent?.url else { return Observable.empty() }
//
//        return Observable.create { emitter in
//            let request = AF.request(
//                url,
//                method: .post,
//                parameters: try? body.toDictionary(),
//                encoding: JSONEncoding.default)
//
//            request
//                .validate(statusCode: 200..<300)
//                .responseDecodable(of: LoginSuccessResponse.self) { response in
//                    switch response.result {
//                    case .success:
//                        if let data = response.value {
//                            emitter.onNext(.success(data))
//                            Console.debug("ACCESSTOKEN: \(data.tokens.accessToken)")
//                        }
//
//                    case .failure(let error):
//                        emitter.onNext(.failure(error))
//                    }
//                }
//            return Disposables.create()
//        }
//    }
}
