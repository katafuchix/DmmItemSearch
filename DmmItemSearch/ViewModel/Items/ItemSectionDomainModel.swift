//
//  ItemSectionDomainModel.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import RxDataSources

/// 一覧用セクション＆データ格納
protocol SectionDomainModelProtocol: SectionModelType {

    /// SectionHeader用文字列
    var header: String { get }
    /// Section内の要素
    var items: [Item] { get set }

    init?(items: [Item])

}

extension SectionDomainModelProtocol {

    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }

}

struct ItemSectionDomainModel: SectionDomainModelProtocol {

    typealias Item = ItemDomainModel

    var header: String { return "" }
    var items: [Item]                   // セルのデータに相当

    init?(items: [Item]) {
        guard items.count > 0 else { return nil }
        self.items = items
    }
}
