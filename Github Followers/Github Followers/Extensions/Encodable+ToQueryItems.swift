//
//  Encodable+ToQueryItems.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation

extension Encodable {
    func toQueryItems() -> [URLQueryItem] {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: JSONEncoder.default.encode(self)) as? [String: Any] else {
                return []
            }
            
            return dictionary
                .sorted(by: { $0.key > $1.key })
                .reduce(into: []) {
                    acc,
                    cur in
                    let (key, value) = cur
                    if let number = value as? NSNumber {
                        switch CFGetTypeID(number as CFTypeRef) {
                        case CFBooleanGetTypeID():
                            if let boolean = value as? Bool {
                                acc.append(
                                    URLQueryItem(
                                        name: key,
                                        value: boolean ? "true" : "fasle"
                                    )
                                )
                            }
                        default:
                            acc.append(
                                .init(
                                    name: key,
                                    value: "\(value)"
                                        .addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                                )
                            )
                        }
                    } else if let items = value as? [Any] {
                        acc.append(
                            contentsOf: items.map({
                                URLQueryItem(
                                    name: key,
                                    value: "\($0)".addingPercentEncoding(
                                        withAllowedCharacters: .alphanumerics
                                    )
                                )
                            })
                        )
                    } else {
                        acc.append(
                            URLQueryItem(
                                name: key,
                                value: "\(value)"
                            )
                        )
                    }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
