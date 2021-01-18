//
//  Observable.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

public final class Observable<Value> {
	struct Observer<Value> {
		weak var observer: AnyObject?
		let callback: (Value) -> Void
	}
	
	private var observers = [Observer<Value>]()
	
	public var value: Value {
		didSet { notifyObservers() }
	}
	
	public init(_ value: Value) {
		self.value = value
	}
	
	public func observe(on observer: AnyObject, observerCallback: @escaping (Value) -> Void) {
		observers.append(Observer(observer: observer, callback: observerCallback))
		observerCallback(self.value)
	}
	
	public func remove(observer: AnyObject) {
		observers = observers.filter { $0.observer !== observer }
	}
	
	private func notifyObservers() {
		for observer in observers {
			DispatchQueue.main.async { observer.callback(self.value) }
		}
	}
}
