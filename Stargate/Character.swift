//
//  Character.swift
//  Stargate
//
//  Created by Jeff Norton on 10/20/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

struct Character {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    let name: String
    let type: String
    let hairColor: String
}

// Purpose: JSON conversion

extension Character {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    
    private static let typeKey = "type"
    private static let hairColorKey = "hair-color"
    
    var endpoint: URL? {
        
        return CharacterController.charactersURL?.appendingPathComponent(self.name).appendingPathExtension("json")
    }
    
    var jsonData: Data? {
        
        return try? JSONSerialization.data(withJSONObject: jsonValue, options: .prettyPrinted)
    }
    
    var jsonValue: [String : String]? {
        
        return [Character.typeKey: self.type, Character.hairColorKey: self.hairColor]
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init?(name: String, dictionary: [String : Any]) {
        
        guard let type = dictionary[Character.typeKey] as? String
            , let hairColor = dictionary[Character.hairColorKey] as? String
            else { return nil }
        
        self.init(name: name, type: type, hairColor: hairColor)
    }
    
}
