//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift

class MemoryStorage: MemoryStorageType{
    
    /// 메모를 저장할 배열, 더미 데이터 추가, 외부에 직접 접근할 이유가 없기 때문에 private, Observable을 통해서 외부로 나감.
    /// 이 Observable은 배열의 상태가 업데이트되면 새로운 Next 이벤트를 방출해야한다.
    /// 그냥 Observable로 하면 이런게 불가능해지므로 Subject를 만들어야함.
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Hello KoreaMango", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    /// 기본 값을 list 로 하기 위해서 lazy로 구현했다.
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
        
    /// 새로운 메모를 생성하고 배열을 추가함
    /// 서브젝트에서 새로운 next 이벤트를 방출하고
    /// 새로운 메모를 방출하는 옵저버블을 리턴함
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        /// BehaviorSubject 에서 onNext로 이렇게 리스트를 갱신하면
        /// Subscribe을 했을 때 가장 최근에 onNext가 된 친구가 갱신되어 나간다.
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    /// Class 외부에서는 리스트에 접근하기 위해서는 이 메소드를 사용해야한다.
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }
    
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
        /// 원본 인스턴스를 새로운 인스턴스로 교환
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
                           
        return Observable.just(updated)
        
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}) {
            list.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
}

