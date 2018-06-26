//
//  ItemDomainModel.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

struct ItemDomainModel {

    var item: ItemEntity!   // 仮にこうする　本来なら項目別にすべき

    init(item: ItemEntity){
        self.item = item
    }
}
