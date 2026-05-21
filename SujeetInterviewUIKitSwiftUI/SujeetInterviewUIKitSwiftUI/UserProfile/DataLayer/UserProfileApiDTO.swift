//
//  UserProfileApiDTO.swift
//  SujeetInterviewUIKitSwiftUI
//
//  Created by Sujeet kumar on 20/05/26.
//

import Foundation

struct UserProfileApiDTO: Codable {
    let first_name: String
    let last_name: String
    let email_id: String
    
    func toDomain() -> UserProfile {
        UserProfile(firstName: first_name, lastName: last_name, emailId: email_id)
    }
}
