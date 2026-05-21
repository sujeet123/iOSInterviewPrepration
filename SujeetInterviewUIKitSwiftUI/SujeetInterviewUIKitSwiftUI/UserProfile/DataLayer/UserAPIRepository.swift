//
//  UserAPIRepository.swift
//  SujeetInterviewUIKitSwiftUI
//
//  Created by Sujeet kumar on 20/05/26.
//

import Foundation

class UserAPIRepositoryImplementation: UserRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchUserProfileDetails() async throws -> UserProfile {
        let userProfilApiDTO: UserProfileApiDTO = try await networkService.request(endPoint: .getUserProfile)
        return userProfilApiDTO.toDomain()
    }
    
    func updateUserProfileDetails(userProfile: UserProfile) async throws {
        let userProfileDTO: UserProfileApiDTO = UserProfileApiDTO(first_name: userProfile.firstName,
                                                                  last_name: userProfile.lastName,
                                                                  email_id: userProfile.emailId)
        try await networkService.requestVoid(endPoint: .saveUserProfile(body: userProfileDTO))
    }
    
    
}
