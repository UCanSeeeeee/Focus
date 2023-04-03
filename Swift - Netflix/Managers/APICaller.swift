//
//  APICaller.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import Foundation
import Alamofire

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    //查看json数据模型
//        AF.request(url).responseJSON { response in
//            print(response.result)
//        }
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }

    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        AF.request(url).responseDecodable { (res: AFDataResponse<TrendingTitleResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.results))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        AF.request(url).responseDecodable { (res: AFDataResponse<YoutubeSearchResponse>) in
            switch res.result {
            case .success(let data):
                completion(.success(data.items[0]))
            case .failure( _):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
}

/*
 let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
     print(Thread.isMainThread)
     guard let data = data, error == nil else {
         return
     }

     do {
         let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
         completion(.success(results.results))
     }
     catch {
         completion(.failure(APIError.failedTogetData))
     }
 }

 task.resume()

 let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
     guard let data = data, error == nil else {
         return
     }
     do {
         let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)

         completion(.success(results.items[0]))


     } catch {
         completion(.failure(error))
         print(error.localizedDescription)
     }

 }
 task.resume()
}
 */

