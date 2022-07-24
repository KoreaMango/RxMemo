//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class MemoDetailViewController: UIViewController, ViewModelBindableType{

    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView : UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton : UIBarButtonItem!
    @IBOutlet weak var shareButton : UIBarButtonItem!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: listTableView.rx.items){ tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default :
                    fatalError()
                }
            }.disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc,animated: true, completion: nil)
            }).disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }
}
