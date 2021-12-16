//
//  URL++.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import IntentsUI
import UniformTypeIdentifiers

extension URL {
    /**
    Creates a unique temporary directory and returns the URL.

    The URL is unique for each call.

    The system ensures the directory is not cleaned up until after the app quits.
    */
    static func uniqueTemporaryDirectory(
        appropriateFor: Self = Bundle.main.bundleURL
    ) throws -> Self {
        try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: appropriateFor,
            create: true
        )
    }
    /**
    Create a `INFile` from the URL.
    */
    var toINFile: INFile {
        INFile(
            fileURL: self,
            filename: lastPathComponent,
            typeIdentifier: contentType?.identifier
        )
    }
}

extension URL {
    private func resourceValue<T>(forKey key: URLResourceKey) -> T? {
        guard let values = try? resourceValues(forKeys: [key]) else {
            return nil
        }

        return values.allValues[key] as? T
    }

    /**
    Set multiple resources values in one go.

    ```
    try destinationURL.setResourceValues {
        if let creationDate = creationDate {
            $0.creationDate = creationDate
        }

        if let modificationDate = modificationDate {
            $0.contentModificationDate = modificationDate
        }
    }
    ```
    */
    func setResourceValues(with closure: (inout URLResourceValues) -> Void) throws {
        var copy = self
        var values = URLResourceValues()
        closure(&values)
        try copy.setResourceValues(values)
    }

    var contentType: UTType? { resourceValue(forKey: .contentTypeKey) }
}
