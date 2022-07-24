//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift

/// CRUD 선언하는 프로토콜
protocol MemoryStorageType{
    
    @discardableResult // 작업결과가 필요없는 결과도 있을 수 있으니 추가.
    func createMemo(content: String) -> Observable<Memo>
    /// Observable로 리턴함으로써 구독자가 작업 결과를 원하는 방식으로 처리할 수 있게 해줌.
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
