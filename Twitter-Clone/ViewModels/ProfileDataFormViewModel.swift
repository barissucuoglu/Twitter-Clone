//
//  ProfileDataFormViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 7.05.2024.
//

import Foundation
import Combine

final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
    
}
