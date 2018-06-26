//
//  ItemsViewModel.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ItemsViewModel {

    // MARK: - Model
    let model: ItemsModel

    // MARK: - rx

    /// ローディング中ならtrue
    var isLoading: Variable<Bool> = Variable(false)

    /// ページング完了時にtrue
    var isFinishedPaging: Variable<Bool> = Variable(false)

    /// APIで取得するページ番号
    var page: Variable<Int> = Variable(0)

    /// APIに投げる検索キーワード
    var keyword: Variable<String> = Variable("")

    /// APIで取得した商品リスト
    var items: Variable<[ItemDomainModel]> = Variable([])

    var sectionItems: Variable<[ItemSectionDomainModel]> = Variable([])

    let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Method

    init(_ model: ItemsModel = ItemsModel()) {
        self.model = model
        subscribe()
    }

    /// 商品検索結果取得
    func fetch() -> Observable<[ItemDomainModel]> {
        return model.fetch(keyword.value, page.value).do(
            onNext: {
                if $0.count == 0 {
                    self.isFinishedPaging.value = true
                    return
                }
                self.items.value.append(contentsOf: $0)
                self.page.value += 1
            }, onError: {
                print($0)
                self.isLoading.value = false
            }, onCompleted: {
                self.isLoading.value = false
            }, onSubscribed: {
                self.isLoading.value = true
            })
    }

    /// 検索初期化
    func refresh() {
        isLoading.value = false
        isFinishedPaging.value = false
        page.value = 1
        sectionItems.value = []
        items.value = []
    }

    private func subscribe() {
        // modelのItemDomainModel配列を監視しSection分け
        items.asObservable().subscribe(onNext: { items in
            guard items.count > 0 else {
                self.sectionItems.value = []
                return
            }
            if self.sectionItems.value.count == 0 {
                self.sectionItems.value.append(ItemSectionDomainModel(items: items)!)
            } else {
                self.sectionItems.value[0].items = items
            }
        }).disposed(by: disposeBag)
    }

    /// 対象のsection, rowのオブジェクトを取得
    func getItem(_ indexPath: IndexPath) -> ItemDomainModel {
        return sectionItems.value[indexPath.section].items[indexPath.row]
    }

    /// セクション配列・セクション内UserDataの末尾位置か調べる
    /// - return: Bool (true -> End of Sections and Rows)
    func isEndOfSections(_ indexPath: IndexPath) -> Bool {
        let lastSection = sectionItems.value.lastIndex
        let lastRow = sectionItems.value[lastSection].items.lastIndex
        return (indexPath.section == lastSection && indexPath.row == lastRow)
    }

}
