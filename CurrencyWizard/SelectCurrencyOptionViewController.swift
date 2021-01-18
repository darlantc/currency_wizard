//
//  SelectCurrencyOptionViewController.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import UIKit

class SelectCurrencyOptionViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var headerLabel: UILabel!
	
	private var viewModel: SelectCurrencyOptionViewModel!

	convenience init(viewModel: SelectCurrencyOptionViewModel) {
		self.init()
		self.viewModel = viewModel
	}
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.bindToViewModel()
		self.viewModel.requestCurrencyOptions()
    }
	
	// MARK: Utilities
	private func bindToViewModel() {
		viewModel.currencyOptionsList.observe(on: self) { _ in self.updateViews() }
	}
	
	private func updateViews() {
		self.tableView.reloadData()
	}
}

// MARK: UITableViewDataSource
extension SelectCurrencyOptionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.currencyOptionsList.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}

// MARK: UITableViewDelegate
extension SelectCurrencyOptionViewController: UITableViewDelegate {
	
}
