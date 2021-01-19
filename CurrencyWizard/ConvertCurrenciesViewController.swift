//
//  ConvertCurrenciesViewController.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import UIKit

class ConvertCurrenciesViewController: UIViewController {
	// MARK: IBOutlet
	@IBOutlet weak var valueTextField: UITextField! {
		didSet {
			valueTextField.addTarget(self,
									 action: #selector(textFieldDidChange(_ :)),
									 for: .editingChanged)
			valueTextField.text = ""
		}
	}
	@IBOutlet weak var fromCurrencyOptionButton: UIButton! {
		didSet {
			fromCurrencyOptionButton?.titleLabel?.textAlignment = .center
		}
	}
	@IBOutlet weak var toCurrencyOptionButton: UIButton! {
		didSet {
			toCurrencyOptionButton?.titleLabel?.textAlignment = .center
		}
	}
	@IBOutlet weak var resultLabel: UILabel! {
		didSet {
			resultLabel.text = "0"
		}
	}
	
	// MARK: IBAction
	@IBAction func didTapFromCurrencyOption(_ sender: Any) {
		viewModel.didWantToChangeFromCurrencyOption()
	}
	
	@IBAction func didTapToCurrencyOption(_ sender: Any) {
		viewModel.didWantToChangeToCurrencyOption()
	}
	
	// MARK: Initialization
	private var viewModel: ConvertCurrenciesViewModel!
	
	convenience init(viewModel: ConvertCurrenciesViewModel) {
		self.init()
		self.viewModel = viewModel
	}
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

		self.bindToViewModel()
    }
	
	// MARK: Utilities
	private func bindToViewModel() {
		viewModel.fromCurrencyOption.observe(on: self) { option in
			self.setTitleTo(button: self.fromCurrencyOptionButton, from: option)
		}
		viewModel.toCurrencyOption.observe(on: self) { option in
			self.setTitleTo(button: self.toCurrencyOptionButton, from: option)
		}
		viewModel.convertedValue.observe(on: self) { convertedValue in
			guard let value = convertedValue else { return }
			self.resultLabel.text = "\(value)"
		}
	}
	
	private func setTitleTo(button: UIButton, from currencyOption: CurrencyOption?) {
		var title = "Selecione..."
		if let option = currencyOption {
			title = "\(option.name) (\(option.id))"
		}
		
		button.setTitle(title, for: .normal)
	}
	
	@objc private func textFieldDidChange(_ textField: UITextField) {
		guard let text = textField.text,
			  !text.isEmpty,
			  let value = NumberFormatter().number(from: text)?.doubleValue
		else {
			viewModel.convert(value: 0)
			return
		}
		viewModel.convert(value: value)
	}
}
