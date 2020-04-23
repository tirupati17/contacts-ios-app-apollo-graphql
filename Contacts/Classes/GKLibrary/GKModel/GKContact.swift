//
//  GKContact.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//


struct ResponseError: Codable {
    let errors: [String]?
    enum CodingKeys: String, CodingKey {
        case errors
    }
}

struct Contact: Codable {
    let id: String
    var firstName, lastName, email, phoneNumber: String?
    var profilePic: String?
    var favorite: Bool = false
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case favorite
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
