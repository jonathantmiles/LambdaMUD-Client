//
//  NetworkController.swift
//  LambdaMUD
//
//  Created by Jonathan T. Miles on 12/11/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation

class NetworkController {
    
    // login method
    func login(username: String, password: String) {
        
        let url = baseURL.appendingPathComponent("login/")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        let dictionary: [String: String] = ["username": username, "password": password]
        do {
            let data = try JSONEncoder().encode(dictionary)
            request.httpBody = data
        } catch {
            NSLog("Error encoding username and password into data")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error logging in to a new account:  \(error)")
            }
            
            if let data = data {
                do {
                    let dict = try JSONDecoder().decode([String: String].self, from: data)
                    self.key = dict["key"]!
                } catch {
                    NSLog("Error decoding data: \(error)")
                }
            } else {
                NSLog("Error decoding data from log-in fetch request")
            }
        }.resume()
        
        
    }
    
    // signup method
    func signup(username: String, password1: String, password2: String) {
        
        let url = baseURL.appendingPathComponent("registration/")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        let dictionary: [String: String] = ["username": username, "password1": password1, "password2": password2]
        do {
            let data = try JSONEncoder().encode(dictionary)
            request.httpBody = data
        } catch {
            NSLog("Error encoding username and password into data: \(error)")
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing up to a new account:  \(error)")
            }
            
            if let data = data {
                do {
                    let dict = try JSONDecoder().decode([String: String].self, from: data)
                    self.key = dict["key"]!
                } catch {
                    NSLog("Error decoding data: \(error)")
                }
            } else {
                NSLog("Error decoding data from signup fetch request")
            }
        }.resume()
    }
    
    // initialize method
    func initialize() {
        
        let url = baseURL.appendingPathComponent("adv/").appendingPathComponent("init/")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token \(key)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error initializing in first room:  \(error)")
            }
            
            if let data = data {
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    self.rooms.append(room)
                } catch {
                    NSLog("Error decoding data: \(error)")
                }
            } else {
                NSLog("Error decoding data from signup fetch request")
            }
        }.resume()
    }
    
    // move method
    func move(direction: String) {
        
        let url = baseURL.appendingPathComponent("adv/").appendingPathComponent("move/")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(key)", forHTTPHeaderField: "Authorization")
        request.setValue("Application/json", forHTTPHeaderField: "Content-type")
        let dictionary: [String: String] = ["direction": direction]
        do {
            let data = try JSONEncoder().encode(dictionary)
            request.httpBody = data
        } catch {
            NSLog("Error encoding move direction into data: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error moving through rooms:  \(error)")
            }
            
            if let data = data {
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    self.rooms = []
                    self.rooms.append(room)
                } catch {
                    NSLog("Error decoding data: \(error)")
                }
            } else {
                NSLog("Error decoding data from signup fetch request")
            }
        }.resume()
    }
    
    // say method
    
    // MARK: - Properties
    
    static var shared = NetworkController()
    
    private var key = "" {
        didSet {
            self.initialize()
        }
    }
    var rooms: [Room] = [] 
    
//    private let baseURL = URL(string: "localhost:8000/api/")!
    private let baseURL = URL(string: "https://adv-project-jtm.herokuapp.com/api/")!
}
