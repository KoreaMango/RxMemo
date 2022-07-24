//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType{

    var viewModel: MemoComposeViewModel!
    
    @IBOutlet weak var cancelButton : UIBarButtonItem!
    @IBOutlet weak var saveButton : UIBarButtonItem!
    @IBOutlet weak var contentTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 먼저 네비게이션 타이틀을 바인딩
    /// 이니션 텍스트를 텍스트 뷰에 바인딩
    /// 메모 쓰기모드에서는 빈 문자열이 표시되고 편집 모드에선 편집될 메모가 표시된다.
    /// 버튼을 바인딩 한다.
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        /// 액션 패턴으로 액션을 구현할 때 액션 속성에 저장하는 방식으로 바인딩된다.
        /// 취소 버튼을 탭하면 캔슬 액션에 랩핑되어있는 코드가 실행된다.
        cancelButton.rx.action = viewModel.cancelAction
        
        /// 저장 버튼은 텍스트 뷰에 있는 문장을 저장해야한다.
        /// 탭 속성에 바인딩을 한다.
        /// 더블 탭을 막기 위해 0.5초마다 한번씩 받는다.
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty) // 텍스트 뷰에 입력된 텍스트를 emit
            .bind(to: viewModel.saveAction.inputs) // 뷰모델의 세이브 액션의 input에 저장
            .disposed(by: rx.disposeBag)
        
    }
    
    
    /// 키보드 입력이 바로 활성화 되도록 viewWillAppear에서 텍스트 뷰를 펄스트 리스폰더를 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
    }
    /// 이전화면으로 돌아가기 전에 설정 해제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }

}
