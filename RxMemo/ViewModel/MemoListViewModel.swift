//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action

/// 쓰기 모드로 화면 전환하는 것은 리스트 뷰에서 해줘야한다.
/// 네브바에 버튼을 누르면 모달 방식으로 표시한다.
class MemoListViewModel : CommonViewModel{
    /// 테이블 뷰와 바인딩할 수 있는 속성을 추가한다.
    /// 이 속성은 메모 배열을 방출한다.
    var memoList : Observable<[Memo]> {
        return storage.memoList()
    }
    
    /// Action을 보면 입력 값이 String 으로 선언되어 있다.
    /// 입력 값으로 메모를 업데이트 하도록 구현한다.
    /// 또한 Observable이 리턴하는 형식이 Void이다.
    /// 반면 업데이트 메소드가 리턴하는 옵저버블은 편집된 메모를 방출한다.
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action {input in
            return self.storage.update(memo: memo, content: input).map{_ in }
        }
    }
    
    /// 생성된 메모를 삭제한다.
    /// 메모를 삭제하지 않으면 불필요한 메모가 푸쉬된다.
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map {_ in}
        }
    }
    
    /// 이 함수를 호출하면 메모가 실제로 생성되고 옵저버블이 방출된다.
    func makeCreateAction() -> CocoaAction {
        return CocoaAction {_ in
            return self.storage.createMemo(content: "") // 크리에이트 메소드를 호출하면 새로운 메모를 생성하고 이 메모를 emit 하는 옵저버블이 나온다. 이어서 flat 맵을 호출하고 화면전환을 처리한다.
                .flatMap{ memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    /// compose Scene을 저장하고 뷰 모델을 저장한다.
                    let composeScene = Scene.compose(composeViewModel)
                    
                    /// 트랜지션 메소드는 Completable을 방출하기 때문에 옵저버블로 바꿔줘야 한다.
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map{_ in }
            }
        }
    }
    
    /// 속성형태로 액션을 생성
    /// 액션의 입력 형식은 메모, 출력형식은 Void 이다.
    /// 클로저 내부에서 셀프에 접근하기 위해 Lazy로 생성했다.
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map{_ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action{ memo in
            return self.storage.delete(memo: memo).ignoreElements().asObservable()
        }
    }()
}
