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
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDataSource
extension SelectCurrencyOptionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}

// MARK: UITableViewDelegate
extension SelectCurrencyOptionViewController: UITableViewDelegate {
	
}
