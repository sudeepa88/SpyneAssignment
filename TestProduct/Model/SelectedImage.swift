//
//  SelectedImage.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 10/11/24.
//

import Foundation
import RealmSwift


class SelectedImage: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageData: Data
    @Persisted var isUploaded: Bool
}
