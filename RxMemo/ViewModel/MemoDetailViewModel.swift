//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel : CommonViewModel {
    let memo: Memo
    
    /// formatter는 날짜를 문자열로 바꿀 때 사용된다.
    private var formatter : DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    /// 테이블 뷰를 바인딩 할 때는 옵저버블과 바인딩한다.
    /// 메모와 Date를 방출하기 때문에 문자열 배열을 받는다.
    /// 메모를 편집한 다음 다시 보기화면으로 오면 편집한 내용이 반영되어야 하기 떄문에
    /// 새로운 문자열을 방출해야한다.
    /// 그래서 BehaviorSubject 를 사용한다.
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoryStorageType){
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
        
    }
    
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable()
            .map{ _ in }
        
    }
    /// 내용을 편집하고 버튼을 탭하면 실행되는 메소드
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action {input in
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    /// 새로운 내용을 서브젝트로 전달
                    /// 이후 서브젝트와 바인딩 되어있는 테이블뷰가 새로운 내용으로 바뀜
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map{_ in }
        }
    }
    
    
    
}
