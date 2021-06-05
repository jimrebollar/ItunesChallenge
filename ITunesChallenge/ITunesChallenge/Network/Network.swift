//
//  Network.swift
//  ITunesChallenge
//
//  Created by Imo on 05/06/21.
//

import Foundation
import SwiftyJSON

class Network {

    static func itunesServiceSearch(searchTerm:String, completion: @escaping (JSON, String) -> Void ) {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var errorMessage:String = ""
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "?country=mx&media=music&entity=album&limit=20&term=\(searchTerm)"
        
            guard let url = urlComponents.url else {
                return
            }
        
            dataTask =
                defaultSession.dataTask(with: url) { data, response, error in
                    defer {
                        dataTask = nil
                    }
    
                    if let error = error {
                        errorMessage += "DataTask error: " +
                            error.localizedDescription + "\n"
                    } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        
                        do {
                            let json = try JSON(data: data)
                            
                            DispatchQueue.main.async {
                                completion( json, errorMessage )
                            }
                        }catch {}
                    }
                }
            dataTask?.resume()
        }
    }
}
