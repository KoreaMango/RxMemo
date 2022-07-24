//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension UIViewController {
    /// 실제로 화면에 표시되어있는 뷰 컨트롤러를 리턴하는 메소드
    var sceneViewController : UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    /// 리소스 정리에 사용되는 DisposeBag
    private let bag = DisposeBag()
    
    /// SceneCoordinator는 화면전환을 담당하기 때문에 window인스턴스와 현재 화면에 표시되어 있는 Scene을 갖고 있어야 한다.
    private var window : UIWindow
    private var currentVC: UIViewController
    
    /// 이것을 상속받을 클래스들가 supe. init 을 안쓰기 위해서 required 로 구현했다.
    required init(window: UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        /// 화면 전환 결과를 방출할 서브젝트
        let subject = PublishSubject<Void>()
        
        /// Scene을 생성해서 상수에 저장
        let target = scene.instantiate()
        
        
        /// Scene 열거형에서 구현한 것.
        switch style {
        case .root:
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
            
        case .push:
            
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            /// 델리게이트 메소드가 호출될 때마다 넥스트 이벤트를 방출한다.
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated){
                subject.onCompleted()
            }
            currentVC = target.sceneViewController        }
        

        return subject.ignoreElements().asCompletable()
    }
    
    
    /// Pusblish Subject 를 생성하지 않고 청므부터 Completable을 생성하면 복잡해진다.
    /// 그와 같은 예시가 아래에 있다.
    /// Create 연산자로 만들어야하고, 클로저 내부에서 구현하는게 복잡해보인다.
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create{[unowned self] completable in
            
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated){
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            
            else {
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
    
    
}
