//
//  LogInViewController.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var txtUsername: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()

    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction private func onBtnLogin(_ sender: UIButton) {
        view.endEditing(true)
        
        viewModel.model.username = txtUsername.text!
        viewModel.model.password = txtPassword.text!
        
        guard viewModel.validation() else {
            // display message
            view.showToastAtBottom(message: viewModel.errorMessage)
            
            return
        }
        
        IndicatorManager.showLoader()
        
        viewModel.login { result in
            IndicatorManager.hideLoader()
            
            switch result {
            case .success(let value):
                print(value)
                // go to next screen
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TODOListViewController") as! TODOListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
                self.view.showToastAtBottom(message: error.localizedDescription)
            }
        }
    }

}
