//
//  ProfileDataFormViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 7.05.2024.
//

import UIKit
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

final class ProfileDataFormViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var url: URL?
    @Published var isFormValid: Bool = false
    @Published var error: String?
    
    
    func validateUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 4,
              let bio = bio,
              bio.count > 2,
              imageData != nil else {
            isFormValid = false
            return
        }
        
        isFormValid = true
    }
    
    
    func uploadAvatar() {
        let randomID = UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] url in
            self?.url = url
        }.store(in: &subscriptions)

    }
    
}
