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
			tableView.isHidden = true
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var headerLabel: UILabel! {
		didSet {
			headerLabel.text = viewModel.headerText
		}
	}
	@IBOutlet weak var loadingView: UIActivityIndicatorView! {
		didSet {
			loadingView.isHidden = false
		}
	}
	
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
		viewModel.isLoading.observe(on: self, observerCallback: self.updateViewsForIsLoading)
	}
	
	private func updateViews() {
		self.tableView.reloadData()
	}
	
	private func updateViewsForIsLoading(isLoading: Bool) {
		print("updateViewsForIsLoading \(isLoading)")
		self.tableView.isHidden = isLoading
		self.loadingView.isHidden = !isLoading
	}
}

// MARK: UITableViewDataSource
extension SelectCurrencyOptionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.currencyOptionsList.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = dequeueReusableCell(for: tableView)
		self.prepare(cell: cell, forIndex: indexPath.row)
		
		return cell
	}
	
	private func dequeueReusableCell(for tableView: UITableView) -> UITableViewCell {
		let cellIdentifier = "cell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
			return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
		}
		return cell
	}
	
	private func prepare(cell: UITableViewCell, forIndex index: Int) {
		let currencyOption = viewModel.currencyOptionsList.value[index]
		cell.textLabel?.text = "\(currencyOption.id) - \(currencyOption.name)"
	}
}

// MARK: UITableViewDelegate
extension SelectCurrencyOptionViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelect(at: indexPath.row)
		viewModel.didFinishWithSelected()
	}
}
