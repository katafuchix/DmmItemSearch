//
//  ItemInfoEntity.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

public struct ItemInfoEntity: Codable {
    public let genre:   [UnitEntity]?
    public let series:  [UnitEntity]?
    public let maker:   [UnitEntity]?
    public let actor:   [UnitEntity]?
    public let author:  [UnitEntity]?
}
