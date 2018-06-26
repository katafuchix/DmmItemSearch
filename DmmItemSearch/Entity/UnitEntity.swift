//
//  UnitEntity.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

public struct UnitEntity: Codable {
    public let id: String?
    public let name: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        // idはSting/Intのどちらかでくる Expected to decode Int but found a string/data instead. 対策
        if let value = try? container.decode(Int.self, forKey: .id) {
            id = String(value)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
    }
}
