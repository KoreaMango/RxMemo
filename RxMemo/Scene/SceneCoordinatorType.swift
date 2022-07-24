//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    /// Scene Coordinator 가 공통적으로 구현해야하는 부분
    /// 두 메소드는 리턴형이 Completable로 구현되어있다.
    /// 여기에 구독자를 추가하고 화면전환이 완료된 후에 원하는 작업을 구현할 수 있다.
    /// 이런 작업이 필요없다면 사용하지 않아도 된다.
    /// discradableResult를 사용했기 떄문에 Return형을 사용하지 않는다는 경고를 발생하지 않는다.
    ///
    /// 이 메소드는 새로운 Scene 을 표시한다.
    /// 파라미터로 대상 Scene과 트랜지션 스타일, 애니메이션 플레그를 전달한다.
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle , animated: Bool) -> Completable
    
    
    /// 이 메소드는 현재 Scene을 닫고 이전 Scene으로 돌아간다.
    @discardableResult
    func close(animated: Bool) -> Completable
    
    
}
