//
//  DMMPageStatus.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

/// ページング機能を持つEntity用のプロトコル
/// - note: 応答JSONの項目と一致します
///
protocol DMMPaging {
    /// 検索開始位置
    //var first_position: Int { get }
    /// 取得件数
    var result_count: Int { get }
    /// トータル件数
    //var total_count: Int { get }

}

/// ページング機能を持つModelに用いるフィールド型
/// - note: 応答JSONの内容を保持し、次のページを参照する際に用います
///
struct DMMPageStatus {
    //let index: Int
    let count: Int
    //let total: Int

    init(paging source: DMMPaging) {
        //index = source.first_position
        count = source.result_count
        //total = source.total_count
    }

    /// 終端かどうかを真偽値で返す
    ///
    //var reachedEnd: Bool {
        // zero originではないため、indexとcountの一致が読み出し完了を示す
    //     return index == count
    //}

}
