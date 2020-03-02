import RxSwift

public protocol DataManagerType {

    func serviceCall<T: Decodable>(apiRequest: RequestModel) -> Single<T>
}
