//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 강민규 on 2022/07/22.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType{

    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView : UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton : UIBarButtonItem!
    @IBOutlet weak var shareButton : UIBarButtonItem!
    
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
