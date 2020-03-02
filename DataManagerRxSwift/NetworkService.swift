import RxSwift

protocol NetworkService {
    
    func serviceCall<T: Decodable>(apiRequest: RequestModel) -> Single<T>
}
