//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action


class MemoComposeViewModel :CommonViewModel{
    /// Compose Scene 에 표시할 메모를 저장하는 속성
    private let content : String?
    
    var initialText : Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
        
    }
    
    /// 저장과 취소 메소드
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(title: String, content: String? = nil , sceneCoordinator: SceneCoordinatorType, storage: MemoryStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil){
        self.content = content
        
        /// 액션이 nil이라 여기서 랩핑
        self.saveAction = Action<String, Void> { input in
            /// 액션이 전달되면 액션을 실행하고 화면을 닫는다.
            if let action = saveAction {
                action.execute(input)
            }
            /// 전달되지 않으면 그냥 화면을 닫는다.
            return sceneCoordinator.close(animated: true).asObservable().map{_ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction{
                action.execute()
            }
            return sceneCoordinator.close(animated: true).asObservable().map{ _ in }
        }
        /// ViewModel에서 취소코드와 저장코드를 직접구현해도 되지만 현재 파라미터로 받는 중이다.
        /// 뷰 모델에서 직접 구현하면 처리 방식이 하나로 고정된다.
        /// 반면 파라미터로 받으면 이전화면에서 처리방식을 동적으로 결정할 수 있다.
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
