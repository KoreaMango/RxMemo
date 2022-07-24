//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/24.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel 에는 의존성을 주입하는 생성자와 바인딩에 사용되는 속성과 메소드가 사용된다.
/// 그리고 화면전환과 메모 저장을 처리한다.
/// Scene 코디네이터와 메모 스토리지를 사용한다.
/// viewmodel을 생성하는 시점에 생성자로 의존성을 주입해야함
///
class CommonViewModel: NSObject {
    /// 앱을 구성하고 있는 모든 Scene은 네비게이션 컨트롤러에 Embed 되기 때문에 Navigation 타이틀이 필요하다.
    let title : Driver<String> /// 이렇게 하면 네비게이션 아이템을 쉽게 바인딩할 수 있다.
    
    /// 두 속성의 타입을 프로토콜로 선언해서 의존성을 쉽게 수정할 수 있다.
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoryStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoryStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
    
}
