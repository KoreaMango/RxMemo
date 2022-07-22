//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel : ViewModelType! {get set}
    
    func bindViewModel()
}

extension ViewModelBindableType where Self : UIViewController {
    mutating func bind(viewModel: Self.ViewModelType){
        self.viewModel = viewModel
        
        loadViewIfNeeded()
        
        bindViewModel()
    }
    
}

