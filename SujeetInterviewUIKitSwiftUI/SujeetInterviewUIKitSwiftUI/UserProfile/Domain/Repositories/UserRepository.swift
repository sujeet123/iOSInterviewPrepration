//
//  UserRepositoryProtocol.swift
//  SujeetInterviewUIKitSwiftUI
//
//  Created by Sujeet kumar on 20/05/26.
//

import Foundation

protocol UserRepository {
    func fetchUserProfileDetails() async throws -> UserProfile
    func updateUserProfileDetails(userProfile: UserProfile) async throws
}
