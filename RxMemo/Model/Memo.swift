//
//  Memo.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxDataSources // RxDataSources는 테이블 뷰와 컬렉션 뷰에 바인딩할 수 있는 데이터 소스를 제공한다.

struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String
    
    /// 생성자 추가
    init(content : String, insertDate: Date = Date()){
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    /// 이 생성자는 업데이트된 내용으로 새로운 메모 인스턴스를 생성할 때 사용된다.
    init(original: Memo, updateContent: String){
        self = original
        self.content = updateContent
    }
}
 
