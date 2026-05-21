//
//  GetUserProfileUseCaseProtocol.swift
//  SujeetInterviewUIKitSwiftUI
//
//  Created by Sujeet kumar on 20/05/26.
//

import Foundation

protocol GetUserProfileUseCaseProtocol {
    func getUserProfileUseCase() async throws -> UserProfile
}

protocol SaveUserProfileUseCaseProtocol {
    func saveUserProfileUseCase(userProfile: UserProfile) async throws
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    func getUserProfileUseCase() async throws -> UserProfile {
        try await userRepository.fetchUserProfileDetails()
    }
}

final class SaveUserProfileUseCase: SaveUserProfileUseCaseProtocol {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func saveUserProfileUseCase(userProfile: UserProfile) async throws {
        try await userRepository.updateUserProfileDetails(userProfile: userProfile)
    }
    
}


