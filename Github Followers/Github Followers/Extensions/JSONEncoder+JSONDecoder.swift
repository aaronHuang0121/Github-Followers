//
//  JSONEncoder+JSONDecoder.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation

extension JSONEncoder {
    static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        encoder.dateEncodingStrategy = .custom { date, encoder in
            let dateString = dateFormatter.string(from: date)
            var container = encoder.singleValueContainer()
            try container.encode(dateString)
        }
        return encoder
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = dateFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
            }
            return date
        })
        return decoder
    }
}
