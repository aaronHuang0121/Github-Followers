//
//  NetworkManager.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10   // 10s
        config.urlCache = .init(
            memoryCapacity: 20 * 1024 * 1024,
            diskCapacity: 30 * 1024 * 1024
        )
        self.session = URLSession(configuration: config)
    }

    private func makeRequest<P: Encodable>(
        httpMethod: HttpMethod,
        endpoint: String,
        params: P?
    ) -> Result<URLRequest, RestError> {
        guard let baseUrl = URL(string: Rest.baseURL), var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            return .failure(.invalidURL(Rest.baseURL))
        }
        component.path = endpoint
        
        guard let url = component.url else {
            return .failure(.invalidURL(Rest.baseURL + endpoint))
        }
        
        if let params {
            component.percentEncodedQueryItems = params.toQueryItems()
        }
        
        Rest.logger.log("\(httpMethod.rawValue): \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        if let token = Bundle.main.infoDictionary?["API_TOKEN"] as? String {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return .success(request)
    }

    private func request<R: Decodable, P: Encodable>(
        httpMethod: HttpMethod,
        endpoint: String,
        params: P?,
        completion: @escaping (Result<R, RestError>) -> Void
    ) {
        switch makeRequest(httpMethod: httpMethod, endpoint: endpoint, params: params) {
        case .success(let request):
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
                    Rest.logger.error("Request error: \(error.localizedDescription)")
                    completion(.failure(.unknowError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse(0)))
                    return
                }

                guard 200...299 ~= httpResponse.statusCode else {
                    completion(.failure(.invalidResponse(httpResponse.statusCode)))
                    return
                }
                
                guard let data else {
                    completion(.failure(.invalidData))
                    return
                }

                do {
                    let result = try JSONDecoder.default.decode(R.self, from: data)
                    completion(.success(result))
                } catch {
                    Rest.logger.error("Invalid data: \(error.localizedDescription)")
                    completion(.failure(.invalidData))
                }
            }
            task.resume()
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }

        if let image = getImageFromCache(url) {
            completion(image)
            return
        }
        Rest.logger.info("Download image: \(urlString)")
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                Rest.logger.error("Download image error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Rest.logger.error("Download image error: \(RestError.invalidResponse(0).localizedDescription)")
                return
            }

            guard 200...299 ~= httpResponse.statusCode else {
                Rest.logger.error("Downalod image error: \(RestError.invalidResponse(httpResponse.statusCode).localizedDescription)")
                return
            }
            
            guard let data, let uiImage = UIImage(data: data) else {
                Rest.logger.error("Download image error: \(RestError.invalidData.localizedDescription)")
                return
            }
            
            completion(uiImage)
        }
        
        task.resume()
    }

    private func getImageFromCache(_ url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let cache = self.session.configuration.urlCache?.cachedResponse(for: request)?.data,
           let uiImage = UIImage(data: cache) else {
            return nil
        }

        return uiImage
    }
}

extension NetworkManager: RestClient {
    func get<R, P>(
        endpoint: String,
        params: P?,
        completion: @escaping (Result<R, RestError>) -> Void
    ) where R : Decodable, P : Encodable {
        request(
            httpMethod: .get,
            endpoint: endpoint,
            params: params,
            completion: completion
        )
    }
}
