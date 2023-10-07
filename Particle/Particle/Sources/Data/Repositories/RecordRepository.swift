//
//  RecordRepository.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/31.
//

import RxSwift
import Alamofire

final class RecordRepository {
    
    func create(record: RecordCreateDTO) -> Observable<AFResult<RecordReadDTO>> {
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/record")

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
            
            let request = AF.request(
                url,
                method: .post ,
                parameters: record.toDictionary(),
                encoding: JSONEncoding.default,
                headers: header)
            
            request
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RecordReadDTO.self) { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            emitter.onNext(.success(data))
                        }
                        
                    case .failure(let err):
                        emitter.onNext(.failure(err))
                    }
                }
            return Disposables.create()
        }
    }
    
    func read(byTitle: String) {}
    func read(byUrl: String) {}
    func read(byTag: String) -> Observable<AFResult<[RecordReadDTO]>> {
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/record/search/by/tag?tag=\(byTag)")

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
            
            let request = AF.request(url, method: .get, headers: header)
            request
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [RecordReadDTO].self) { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            emitter.onNext(.success(data))
                        }
                        
                    case .failure(let err):
                        emitter.onNext(.failure(err))
                    }
                }
            return Disposables.create()
        }
    }
    
    func readMyRecord() -> Observable<AFResult<[RecordReadDTO]>> {
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/record/my")

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
            
            let request = AF.request(url, method: .get, headers: header)
            request
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [RecordReadDTO].self) { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            emitter.onNext(.success(data))
                        }
                        
                    case .failure(let err):
                        emitter.onNext(.failure(err))
                    }
                }
            return Disposables.create()
        }
    }
    
    func update(recordId: String, to newRecord: RecordCreateDTO) {}
    
    func delete(recordId: String) -> Observable<AFResult<String>> {
        let urlComponent = URLComponents(string: "https://particle.k-net.kr/api/v1/record/\(recordId)")

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
            
            let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
            request
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let data):
                        
                        emitter.onNext(.success(data))
                        
                    case .failure(let error):
                        emitter.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
