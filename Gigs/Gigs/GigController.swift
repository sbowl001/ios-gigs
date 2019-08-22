//
//  GigController.swift
//  Gigs
//
//  Created by Stephanie Bowles on 5/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import UIKit


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
     case put = "PUT"
    case delete = "DELETE"
}
enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    //    An array of Gigs
    var gigs : [Gig] = []
    
//    A Bearer?
    var bearer: Bearer?
    
//    A base URL
    
    private let baseURL = URL(string:"https://lambdagigs.vapor.cloud/api")!
    

    
//    Signing up for the API using a username and password. Once you "sign up", you can then log into the API like you did in the guided project this morning.
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("/users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
            
        }
        URLSession.shared.dataTask(with: request) {(_, response, error)  in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
                    
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        } .resume()
    }
//    Logging in to the API using a username and password. This will give you back a token in JSON data. Decode a Bearer object from this data and set the value of bearer property you made in this GigController so you can authenticate the requests that require it.
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        let loginURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // what is this doing?
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                print("Error making loggin network task: \(error.localizedDescription)")
                completion(error)
                return
            }
            guard let data = data else {
                print("error in the data of the login data task: \(NSError())")
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("error decoding bearer object: \(error)")
                completion(error)
                return
                
            }
            completion(nil)
        } .resume()
    }
//    Getting all the gigs the API has. Once you decode the Gigs, set the value of the array of Gigs property you made in this GigController to it, so the table view controller can have a data source.
//    func getAllGigs(completion: @escaping ([String]) -> Void) {
     func getAllGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = self.bearer else {
            completion(NSError())
            return
        }
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding gig objects: \(error)")
                completion(error)
                return
            }
        } . resume()
    }
//    Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of Gigs.
    
    func createGig(title: String, description: String, dueDate: Date, completion: @escaping (Error?) -> ()) {
        
        let newGig = Gig(title: title, description: description, dueDate: dueDate)
        
        guard let bearer = self.bearer else {
            NSLog("No bearer token")
            completion(nil)
            return
        }
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // what did this do?
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
//        encoder.dateEncodingStrategy = .iso8601   <- encodes date as string
         print("\(bearer.token)")
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(newGig)
        } catch {
            NSLog("Error encoding gig: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let _ = error {
                completion(error)
                return
            }
            self.gigs.append(newGig)
            completion(nil)
            
            } . resume()
    }
}
