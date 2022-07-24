//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit

///  뷰모델의 타입은 뷰컨트롤러마다 달라진다.
protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel : ViewModelType! {get set}
    
    func bindViewModel()
}

/// 뷰컨트롤러에서 추가된 뷰 모델 속성의 실제 뷰 모델을 저장하고 바인드 뷰 모델 메소드를 자동으로 호출하는 메소드 구현
/// 이렇게 하면 개별 뷰 컨트롤러에서 바인드 뷰 모델 메소드를 직접 호출할 필요가 사라짐. 
extension ViewModelBindableType where Self : UIViewController {
    mutating func bind(viewModel: Self.ViewModelType){
        self.viewModel = viewModel
        
        loadViewIfNeeded()
        
        bindViewModel()
    }
    
}

