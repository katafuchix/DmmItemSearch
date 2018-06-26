//
//  ActressViewModel.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/22.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ActressViewModel {

    // MARK: - Model
    let model: ActressesModel

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
    var items: Variable<[ActressEntity]> = Variable([])

    let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Method

    init(_ model: ActressesModel = ActressesModel()) {
        self.model = model
    }
    
    /// 女優検索結果取得
    func fetch() -> Observable<[ActressEntity]> {
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
                },onCompleted: {
                    self.isLoading.value = false
                }, onSubscribed: {
                    self.isLoading.value = true
            })//.debug()
    }

    /// 検索初期化
    func refresh() {
        isLoading.value = false
        isFinishedPaging.value = false
        page.value = 1
        items.value = []
    }
    
    /// セクション配列・セクション内UserDataの末尾位置か調べる
    /// - return: Bool (true -> End of Sections and Rows)
    func isEndOfSections(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == items.value.lastIndex
    }

}
