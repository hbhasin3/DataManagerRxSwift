import RxSwift

public class DataManager: NSObject {
  private let disposeBag = DisposeBag()
  
  private let apiService: NetworkService
  
  public override init() {
    self.apiService = NetworkHandler()
    super.init()
  }
    
    private func fetch<Model: Decodable>(network: Single<[Model]>) -> Observable<[Model]> {
        return Observable.create { observer in
            
            let networkSub = network
                .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { newObjectsArray in
                    observer.onNext(newObjectsArray)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
            return Disposables.create {
                
                networkSub.dispose()
            }
        }
    }
    
    private func fetch<Model: Decodable>(network: Single<Model>) -> Single<Model> {
        
        return Single<Model>.create { single in
            
            let networkSub = network
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { data in
                    single(.success(data))
                }, onError: { error in
                    single(.error(error))
                })
            
            return Disposables.create {
                networkSub.dispose()
            }
        }
    }
}

extension DataManager: DataManagerType {

    
    public func serviceCall<T: Decodable>(apiRequest: RequestModel) -> Single<T> {
        return fetch(network: apiService.serviceCall(apiRequest: apiRequest))
    }
}
