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
