//
//  RESTRequestService.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import Foundation


protocol RESTRequestServiceProtocol {
    static func run<T: Decodable>(_ request: MovieMindsRequestProtocol, responseModel: T.Type) async throws -> T
}

struct RESTRequestService: RESTRequestServiceProtocol {
    private static func parseResponse<T: Decodable>(_ data: Data) throws -> T {
        
        let parseableData: Data = data.isEmpty ? "{}".data(using: .utf8)! : data
        let decodedResponse = try JSONDecoder().decode(T.self, from: parseableData)
        
        return decodedResponse
    }
    
    static func run<T: Decodable>(_ request: MovieMindsRequestProtocol, responseModel: T.Type) async throws -> T {
        do {
            let requestWithToken = try request.createURLRequest()
            
            print("Request = \(String(describing: requestWithToken.url))")
            
            let (data, response) = try await URLSession.shared.data(for: requestWithToken, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RESTRequestError.noResponse
            }
            switch response.statusCode {
            case 200...299:
                return try parseResponse(data)
            case 401:
                print("Request response = \(RESTRequestError.unauthorized.customMessage)")
                throw RESTRequestError.unauthorized
            default:
                throw RESTRequestError.unexpectedStatusCode(response.statusCode)
            }
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            throw RESTRequestError.decode
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw RESTRequestError.decode
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw RESTRequestError.decode
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw RESTRequestError.decode
        } catch let error as RESTRequestError {
            throw error
        } catch {
            let urlError = error as NSError
            if urlError.code == NSURLErrorNotConnectedToInternet {
                throw RESTRequestError.notConnectedToInternet
            } else {
                throw RESTRequestError.unknown
            }
        }
    }
}
