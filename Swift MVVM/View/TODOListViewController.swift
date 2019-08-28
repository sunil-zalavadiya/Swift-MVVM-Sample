//
//  TODOListViewController.swift
//  Swift MVVM
//
//  Created by Kartum on 28/08/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import UIKit

class TODOTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var lblId: UILabel!
    @IBOutlet private weak var lblTitle: UILabel!
    
    // MARK: - Properties
    var model: TODOModel? {
        didSet {
            guard let model = model else {
                return
            }
            lblId.text = "TODO #" + model.getId
            lblTitle.text = model.title
            accessoryType = model.completed ? .checkmark : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TODOListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tblTodos: UITableView!
    
    // MARK: - Properties
    private var viewModel = TODOListViewModel()

    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        title = "TODO"
        tblTodos.delegate = self
        tblTodos.dataSource = self
        
        fetchTodos()
    }

    private func fetchTodos() {
        IndicatorManager.showLoader()
        
        /*viewModel.fetchTodos { result in
            IndicatorManager.hideLoader()
            
            switch result {
            case .failure(let error):
                self.view.showToastAtBottom(message: error.localizedDescription)
            case .success( _):
                // reload table
                DispatchQueue.main.async {
                    self.tblTodos.reloadData()
                }
            }
        }*/
        
        viewModel.fetchTodo { result in
            IndicatorManager.hideLoader()
            
            switch result {
            case .failure(let error):
                self.view.showToastAtBottom(message: error.localizedDescription)
            case .success( _):
                // reload table
                DispatchQueue.main.async {
                    self.tblTodos.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TODOListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TODOTableViewCell") as! TODOTableViewCell
        cell.model = viewModel.getTodo(index: indexPath.row)
        return cell
    }
}
