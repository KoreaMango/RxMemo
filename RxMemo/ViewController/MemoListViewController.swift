//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoListViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func bindViewModel() {
        /// ViewModel에 저장되어 있는 타이틀을 네비게이션 타이틀에 바인드
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        /// 메모 목록을 테이블 뷰에 바인드
        /// 옵저버블과 테이블 뷰를 바인드하는 방식으로
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")){ row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        /// 데이터 소스 메소드 구현 없이 이렇게 짧게 구현 가능하다.
        /// 그리고 셀을 재사용 큐에서 리턴하는 부분도 자동으로 처리되서
        /// 클로져에서 셀 구성코드만 구현하면 된다.
        
        addButton.rx.action = viewModel.makeCreateAction()
    }

}
