//
//  ActressEntity.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

public struct ActressEntity: Codable {

    public let id: String?
    public let name: String?
    public let ruby: String?
    public let bust: String?
    public let cup: String?
    public let waist: String?
    public let hip: String?
    public let birthday: String?
    public let blood_type: String?
    public let hobby: String?
    public let prefectures: String?
    public let imageURL: ImageURLEntity?
    public let listURL: ListURLEntity?
    
    public static func ==(lhs: ActressEntity, rhs: ActressEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
