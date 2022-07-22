//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle , animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
