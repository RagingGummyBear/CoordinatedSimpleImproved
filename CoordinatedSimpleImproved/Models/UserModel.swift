//
//  UserModel.swift
//  CoordinatedSimpleImproved
//
//  Created by Seavus on 5/8/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation

class UserModel: Codable {
    
    var id: Int!
    var name: String!
    var username: String!
    var email: String!
    var address: UserAddress!
    var phone: String!
    var website: String!
    var company: UserCompany!
    
    init(id: Int, name:String, username:String, email:String, phone:String, website:String, address:UserAddress, company:UserCompany) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
        case address
        case phone
        case website
        case company
    }
}

class UserAddress: Codable {
    var street: String!
    var suite: String!
    var city: String!
    var zipcode: String!
    var geo: UserGeo!
    
    enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipcode
        case geo
    }
    
    init(street:String, suite: String, city: String, zipcode: String, geo: UserGeo) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
    
    init(street:String, suite: String, city: String, zipcode: String) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = UserGeo(lat: "0", lng: "0")
    }
}

class UserGeo: Codable {
    var lat: String!
    var lng: String!
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    init(lat:String, lng: String){
        self.lat = lat
        self.lng = lng
    }
}

class UserCompany: Codable {
    var name: String!
    var catchPhrase: String!
    var bs: String!
    
    enum CodingKeys: String, CodingKey {
        case name
        case catchPhrase
        case bs
    }
    
    init(name:String, catchPhrase: String, bs:String){
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
