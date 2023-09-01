//
//  UserRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/30.
//

import Alamofire
import RxSwift

final class UserRepository {
    
    func fetchMyProfile() {
        
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/user/my/profile")

        guard let url = urlComponent?.url else {
            return
        }
        
        guard let accessToken = UserDefaults.standard.string(forKey: "ACCESSTOKEN") else {
            Console.error("AccessToken 이 존재하지 않습니다.")
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserReadDTO.self) { response in
                switch response.result {
                case .success:
                    if let data = response.value {
                        print(data)
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
    }
    
    func setTags(items: [String]) -> Observable<AFResult<UserReadDTO>> {
        var urlString = "https://particle.k-net.kr/api/v1/user/interested/tags?"
        items.forEach {
            urlString += "interestedTags=\($0)&"
        }
        _ = urlString.popLast()
        let urlComponent = URLComponents(string: urlString)

        guard let url = urlComponent?.url else {
            return Observable.empty()
        }
        
        guard let accessToken = UserDefaults.standard.string(forKey: "ACCESSTOKEN") else {
            Console.error("AccessToken 이 존재하지 않습니다.")
            return Observable.empty()
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        return Observable.create { emitter in
            
            let request = AF.request(url, method: .put, headers: header)
            request
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserReadDTO.self) { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            Console.log("success \(#function) \(data)")
                            emitter.onNext(.success(data))
                        }
                        
                    case .failure(let err):
                        emitter.onNext(.failure(err))
                    }
                }
            return Disposables.create()
        }
    }
}
