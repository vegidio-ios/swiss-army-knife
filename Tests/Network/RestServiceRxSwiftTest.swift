import XCTest
import RxSwift
import SAKNetwork

final class RestServiceRxSwiftTest: XCTestCase
{
    let bag = DisposeBag()
    var restFactory: RestFactory!
    
    override func setUp()
    {
        restFactory = RestFactory().apply {
            $0.cacheConfig = CacheConfig(10 * 1_024 * 1_024, 1, .day)
        }
    }
    
    func testOKResponse()
    {
        let servive = restFactory.create(clazz: CountriesService.self)
        
        servive.getCountryBy(countryCode: "BR")
            .subscribe(onSuccess: { country in
                
            }, onError: { error in
                
            }).disposed(by: bag)
    }
}
