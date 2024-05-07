//
//  StorageManager.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 7.05.2024.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FireStorageError: Error {
    case invalidImageID
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func uploadProfilePhoto(with photoID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        
        return storage.reference()
            .child("images/\(photoID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FireStorageError.invalidImageID).eraseToAnyPublisher()
        }
        return storage.reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
}
