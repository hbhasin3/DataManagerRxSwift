DataManagerRxSwift is a lightweight Service Manager utility. Here are some of the highlights:

* Encapsulates the boilerplate associated with network calls.
* Make sure that the network calls are always make on the background thread.

Requirements
iOS 10.0
, Swift 4.0
, RxSwift 4.0

Installation
DataManager is available through CocoaPods. To install it, simply add the following line to your Podfile:

```swift
pod 'DataManagerRxSwift'
```

Usage

Setup

When your controller is loaded, initialize DataManager and DisposeBag globally:

```swift
  import DataManagerRxSwift
  import RxSwift
```

```swift
  var dataManager = DataManager()
  var disposeBag = DisposeBag()
```

To Make a service call you need to setup the request model.


```swift
let requestModel = RequestModel(url: serviceRequestModel.baseURL, path: serviceRequestModel.path.rawValue, method: serviceRequestModel.method.rawValue, header: serviceRequestModel.header, bodyParameters: serviceRequestModel.bodyParameters, getRequestParameters: serviceRequestModel.getRequestParameters)
```
DataManager uses generics so you don't have to worry about casting the response to the service class every time you perform a service call. You just need to define what type of model you want from the manager in the success and that model should be of type Decodable or Codable. For Example

This is a service model of receipt validation from itunes server for In App Subscription validation check

```swift
class VerifyReceipt : NSObject, Codable {
    
    var environment : String?
    var latest_receipt : String?
    var latest_receipt_info : [LatestReceiptInfo]?
    var pending_renewal_info : [PendingRenewalInfo]?
    var receipt : Receipt?
    var status : Int?
}

class Receipt : NSObject, Codable {
    
    var adam_id : Int?
    var app_item_id : Int?
    var application_version : String?
    var bundle_id : String?
    var download_id : Int?
    var in_app : [InApp]?
    var original_application_version : String?
    var original_purchase_date : String?
    var original_purchase_date_ms : String?
    var original_purchase_date_pst : String?
    var receipt_creation_date : String?
    var receipt_creation_date_ms : String?
    var receipt_creation_date_pst : String?
    var receipt_type : String?
    var request_date : String?
    var request_date_ms : String?
    var request_date_pst : String?
    var version_external_identifier : Int?
    
}

class InApp : NSObject, Codable {
    
    var expires_date : String?
    var expires_date_ms : String?
    var expires_date_pst : String?
    var is_in_intro_offer_period : String?
    var is_trial_period : String?
    var original_purchase_date : String?
    var original_purchase_date_ms : String?
    var original_purchase_date_pst : String?
    var original_transaction_id : String?
    var product_id : String?
    var purchase_date : String?
    var purchase_date_ms : String?
    var purchase_date_pst : String?
    var quantity : String?
    var transaction_id : String?
    var web_order_line_item_id : String?
    
}

class PendingRenewalInfo : NSObject, Codable {
    
    var auto_renew_product_id : String?
    var auto_renew_status : String?
    var original_transaction_id : String?
    var product_id : String?
    
}

class LatestReceiptInfo : NSObject, Codable {
    
    var expires_date : String?
    var expires_date_ms : String?
    var expires_date_pst : String?
    var is_in_intro_offer_period : String?
    var is_trial_period : String?
    var original_purchase_date : String?
    var original_purchase_date_ms : String?
    var original_purchase_date_pst : String?
    var original_transaction_id : String?
    var product_id : String?
    var purchase_date : String?
    var purchase_date_ms : String?
    var purchase_date_pst : String?
    var quantity : String?
    var subscription_group_identifier : String?
    var transaction_id : String?
    var web_order_line_item_id : String?
}
```


```swift
dataManager.serviceCall(apiRequest: requestModel).subscribe(onSuccess: { [weak self] (model: VerifyReceipt) in
                guard let strongSelf = self else { return }
                if let date = strongSelf.getExpirationDate(model: model) {
                    print(date)
                }
            }) { (error: Error) in
                print(error.localizedDescription)
                }.disposed(by: self.disposeBag)

```
