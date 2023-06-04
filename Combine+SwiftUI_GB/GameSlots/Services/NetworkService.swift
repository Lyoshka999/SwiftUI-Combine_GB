//
//  NetworkService.swift
//  Combine+SwiftUI_GB
//
//  Created by Алексей on 04.06.2023.
//

import Foundation
import Combine

final class NetworkService {
    typealias asteroids = (key: String, value: [NearEarthObject])
    
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "APIClient",
                                      qos: .default,
                                      attributes: .concurrent)
    
    private func fetchAPOD(startDate: String,
                           endDate: String) -> AnyPublisher<APODResponse, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: EndPoint.APOD(start: startDate, end: endDate).url)
            .receive(on: queue)
            .map{ $0.data }
            .decode(type: APODResponse.self, decoder: decoder)
            .mapError{ (error) -> APIError in
                switch error {
                case is URLError:
                    return APIError.unreachableAddress(
                        url: EndPoint.APOD(start: startDate, end: endDate).url
                    )
                case is DecodingError:
                    return APIError.decodingError
                default:
                    return APIError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchNew(startDate: String,
                          endDate: String) -> AnyPublisher<NewResponse, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: EndPoint.New(start: startDate, end: endDate).url)
            .receive(on: queue)
            .map{ $0.data }
            .decode(type: NewResponse.self, decoder: decoder)
            .mapError{ (error) -> APIError in
                switch error {
                case is URLError:
                    return APIError.unreachableAddress(
                        url: EndPoint.New(start: startDate, end: endDate).url
                    )
                case is DecodingError:
                    return APIError.decodingError
                default:
                    return APIError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSkyInfo(startDate: String,
                      endDate: String) -> AnyPublisher<(APOD,asteroids),APIError> {
        let initialPublisher = fetchAPOD(startDate: startDate, endDate: endDate)
            .flatMap{ $0.publisher }
        
        return initialPublisher
            .zip(
                fetchNew(startDate: startDate, endDate: endDate)
                    .flatMap { value in
                        value.nearEarthObjects.sorted{ $0.key < $1.key }.publisher
                    }
            )
            .eraseToAnyPublisher()
    }
}

// MARK: - NetworkService enums extension
extension NetworkService {
    
    // Request types
    enum EndPoint {
        static let baseURL = URL(string: "https://api.nasa.gov/")!
        // MARK: Get your own key, it's free :) https://api.nasa.gov
        static let NASAKey = "okiOhFbD6p2D9D27aQTRMe5indoyyWOuo72CxLj5"
        
        case New(start: String, end: String)
        case APOD(start: String, end: String)
        
        var url: URL {
            switch self {
            case .New(let startDate, let endDate):
                var baseQueryURL = URLComponents(
                    url: EndPoint.baseURL.appendingPathComponent("new/rest/v1/feed"),
                    resolvingAgainstBaseURL: false)!
                
                baseQueryURL.queryItems = [
                    URLQueryItem(name: "api_key", value: EndPoint.NASAKey),
                    URLQueryItem(name: "start_date", value: startDate),
                    URLQueryItem(name: "end_date", value: endDate)
                ]
                return baseQueryURL.url!
                
            case .APOD(let startDate, let endDate):
                var baseQueryURL = URLComponents(
                    url: EndPoint.baseURL.appendingPathComponent("planetary/apod"),
                    resolvingAgainstBaseURL: false)!
                
                baseQueryURL.queryItems = [
                    URLQueryItem(name: "api_key", value: EndPoint.NASAKey),
                    URLQueryItem(name: "start_date", value: startDate),
                    URLQueryItem(name: "end_date", value: endDate)
                ]
                return baseQueryURL.url!
            }
        }
    }
    
    // Error types
    enum APIError: LocalizedError, Identifiable {
        var id: String { localizedDescription }
        
        case unreachableAddress(url: URL)
        case invalidResponse
        case decodingError
        
        var errorDescription: String? {
            switch self {
            case .unreachableAddress(let url):
                return "\(url.absoluteString) is unreachable"
            case .invalidResponse:
                return "Response with mistake"
            case .decodingError:
                return "Can't decode data"
            }
        }
    }
}
