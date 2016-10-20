//
//  CharacterController.swift
//  Stargate
//
//  Created by Jeff Norton on 10/20/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

class CharacterController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://stargate-2142b.firebaseio.com/api")
    static let charactersURL = baseURL?.appendingPathComponent("characters/stargate-sg1")
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    static func putIntoAPI(characterName name: String, withType type: String, andHairColor hairColor: String) {
        
        let character = Character(name: name, type: type, hairColor: hairColor)
        guard let characterPutURL = character.endpoint else { return }
        
        NetworkController.performRequest(for: characterPutURL, httpMethod: .Put, body: character.jsonData) { (data, error) in
            
            guard let data = data 
                , let responseDataString = String(data: data, encoding: .utf8)
                else {
                    
                    NSLog("Error serializing JSON data.")
                    return
                }
            
            if error != nil {
                
                NSLog("Error: \(error?.localizedDescription)")
                
            } else if responseDataString.contains("error") {
                
                NSLog("Error: \(responseDataString)")
                
            } else {
                
                NSLog("Successfully saved data to endpoint.\nResponse: \(responseDataString)")
            }
        }
    }
    
    static func getFromAPI(allCharacters completion: @escaping (_ characters: [Character]?) -> Void) {
        
        guard let charactersURL = charactersURL else { return }
        
        NetworkController.performRequest(for: charactersURL, httpMethod: .Get) { (data, error) in
            
            let responseDataString = String(data: data!, encoding: .utf8) ?? ""
            
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                completion([])
                return
            } else if responseDataString.contains("error") {
                print("Error: \(responseDataString)")
                completion([])
                return
            }
            
            guard let data = data,
                let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:[String:Any]] else {
                    completion([])
                    return
            }
            
            let characters = jsonDictionary.flatMap { Character(name: $0.0, dictionary: $0.1) }
            completion(characters)
        }
    }
}































