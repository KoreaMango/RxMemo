//
//  Scene.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit
/// 앱에서 구현할 Scene을 열거형으로 선언
/// Scene과 연관된 VeiwModel을 연관값으로 선언
enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoCoposeViewModel)
}
/// 스토리보드에 있는 Scene 을 생성하고
/// 연관 값이 저장된 뷰 모델을 Binding 해서 리턴하는 메소드를 구현한다.
extension Scene {
    
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            /// 메모 목록 Scene을 생성한 다음 ViewModel 을 바인딩해서 리턴함
            /// 스토리보드 아이디를 ListNav로 설정했음.
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            /// ViewModel은 네비게이션 컨트롤러에 임베드 되어있는 루트 뷰 컨트롤러에 바인딩한다.
            /// 리턴할 때는 네비게이션 컨트롤러를 리턴한다.
            listVC.bind(viewModel: viewModel)
            
            return nav
            
            
        case .detail(let viewModel):
            /// 이 Scene은 항상 네비게이션 스택에 푸시되기 때문에  네비게이션 컨트롤러를 고려할 필요가 없다.
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC
            
            
        case .compose(let viewModel):
            /// 메모 목록과 유사하다.
            /// 스토리보드에 네비게이션 컨트롤러가 있는 친구만 이렇게 nav를 따로 만들어준다.
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: viewModel)
            return nav
        }
    }
}
