//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel : CommonViewModel{
    /// 테이블 뷰와 바인딩할 수 있는 속성을 추가한다.
    /// 이 속성은 메모 배열을 방출한다.
    var memoList : Observable<[Memo]> {
        return storage.memoList()
    }
    
}
