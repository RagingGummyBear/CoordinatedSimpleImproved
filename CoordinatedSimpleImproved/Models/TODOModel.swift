//
//  TODOModel.swift
//  CoordinatedSimpleImproved
//
//  Created by Seavus on 5/8/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class ToDoModel: Codable {
    var userId:Int!
    var id:Int!
    var title:String!
    var completed: Bool!
    
    init(id:Int, userId: Int, title:String, completed: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.completed = completed
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case completed
    }
}
