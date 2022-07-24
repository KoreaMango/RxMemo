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
        
        /// 테이블 뷰에서 메모를 선택하면 뷰모델을 통해서 디테일 액션을 전달하고
        /// 선택한 셀은 선택해제 한다.
        /// 1. 선택한 메모
        /// 2. 인덱스 패스
        /// Rxcocoa 는 선택 이벤트 처리에 사용하는 다양한 멤버를 익스텐션으로 제공한다.
        /// 선택한 인덱스가 필요한 경우 itemSelected 속성을
        /// 선택한 데이터가 필요한 경우 modelSelected 속성을
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected) // 이렇게 하면 선택한 메모와 인덱스 패스가 튜플로 나옴
            .do(onNext: { [unowned self] (_ , indexPath) in
                self.listTableView.deselectRow(at: indexPath, animated: true)
            })
            .map{ $0.0}
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
    
        /// 테이블 뷰에서 스와이프 델리트 기능을 활성화하고 삭제 버튼과 액션을 바인딩한다.
        /// 이번에도 델리게이트 메소드를 직접 구현하지 않고 rxcocoa를 통해 구현한다.
        listTableView.rx.modelDeleted(Memo.self) // 메모를 삭제할 때마다 넥스트 이벤트를 방출하는 컨트롤 이벤트를 리턴한다.
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
    }
}
