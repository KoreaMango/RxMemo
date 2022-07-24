//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation

/// 전환 방식을 표현하는 열거형이다.
enum TransitionStyle {
    case root
    case push
    case modal
}


enum TransitionError : Error{
    case navigationControllerMissing
    case cannotPop
    case unknown
    
}
