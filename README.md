# DmmItemSearch
RxSwift + DMM API + APIKit + Codable MVVM Sample

## Getting Started
create Constants.swift like this.
```
struct Constants {
    // APIID
    static let api_id           = " YOUR DMM API ID "
    // アフィリエイトID
    static let affiliate_id     = " YOUR DMM AFFILIATE ID "
    // 1ページに表示する件数
    static let hits             = 10
    // 出力形式
    static let output           = "json"
}
```
after put Constants.swift in this project, pod install.

### Examples in this xcode project
- getting items from DMM API with API Kit, Codable, Rx.
- creating table with RxDataSources, without RxDataSources.
- extended MBProgressHUD with Reactive.
- example of MVVM base.

### Screen capture
<div>
<img src="https://user-images.githubusercontent.com/6063541/41900619-1a527118-796a-11e8-977d-f7b15c9f80d3.png" width="250">
　
<img src="https://user-images.githubusercontent.com/6063541/41900620-1aefa136-796a-11e8-8c33-dfcfcad06893.png" width="250">
　
<img src="https://user-images.githubusercontent.com/6063541/41900623-1bba14ac-796a-11e8-982e-ce184b589b01.png" width="250">
</div>
