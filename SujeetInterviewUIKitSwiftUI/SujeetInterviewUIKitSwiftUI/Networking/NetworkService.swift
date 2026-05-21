//
//  NetworkService.swift
//  SujeetInterviewUIKitSwiftUI
//
//  Created by Sujeet kumar on 20/05/26.
//

import Foundation

enum EndPoint {
    case getUserProfile
    case saveUserProfile(body: Codable)
    
    var path: String {
        switch self {
        case .getUserProfile:
            return "/users"
        case .saveUserProfile:
            return "/saveUserProfile"
        }
    }
    
    var method: String {
        switch self {
        case .getUserProfile:
            return "GET"
        case .saveUserProfile:
            return "POST"
        }
    }
    
    var body: Codable? {
        switch self {
        case .getUserProfile:
            return nil
        case .saveUserProfile(let body):
            return body
        }
    }
}

enum NetworkError: Error {
    case inValidURL
    case inValidResponse
    case decodingFailed
    case serverError(statusCode: Int)
}

protocol NetworkServiceProtocol {
    func request<T: Codable>(endPoint: EndPoint) async throws -> T
    func requestVoid(endPoint: EndPoint) async throws //No response Needed
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = "https://api.example.com",
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T>(endPoint: EndPoint) async throws -> T where T : Decodable, T : Encodable {
        guard let url = URL(string: baseURL + endPoint.path) else {
            throw NetworkError.inValidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = endPoint.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.decodingFailed
            }
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.inValidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func requestVoid(endPoint: EndPoint) async throws {
        guard let url = URL(string: baseURL + endPoint.path) else {
            throw NetworkError.inValidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = endPoint.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.decodingFailed
            }
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.inValidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}


struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    
    init(_ codable: Encodable) {
        encodeFunc = codable.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}

