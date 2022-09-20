//
//  RxTableViewDataSourceProxy.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 6/15/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
    
extension UITableView: HasDataSource {
    public typealias DataSource = UITableViewDataSource
}

private let tableViewDataSourceNotSet = TableViewDataSourceNotSet()

private final class TableViewDataSourceNotSet
    : NSObject
    , UITableViewDataSource {

    func tableView(_ foodSelectedTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ foodSelectedTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rxAbstractMethod(message: dataSourceNotSet)
    }
}

/// For more information take a look at `DelegateProxyType`.
open class RxTableViewDataSourceProxy
    : DelegateProxy<UITableView, UITableViewDataSource>
    , DelegateProxyType {

    /// Typed parent object.
    public weak private(set) var foodSelectedTableView: UITableView?

    /// - parameter tableView: Parent object for delegate proxy.
    public init(foodSelectedTableView: UITableView) {
        self.foodSelectedTableView = foodSelectedTableView
        super.init(parentObject: foodSelectedTableView, delegateProxy: RxTableViewDataSourceProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxTableViewDataSourceProxy(foodSelectedTableView: $0) }
    }

    private weak var _requiredMethodsDataSource: UITableViewDataSource? = tableViewDataSourceNotSet

    /// For more information take a look at `DelegateProxyType`.
    open override func setForwardToDelegate(_ forwardToDelegate: UITableViewDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate  ?? tableViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}

extension RxTableViewDataSourceProxy: UITableViewDataSource {
    /// Required delegate method implementation.
    public func tableView(_ foodSelectedTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (_requiredMethodsDataSource ?? tableViewDataSourceNotSet).tableView(foodSelectedTableView, numberOfRowsInSection: section)
    }

    /// Required delegate method implementation.
    public func tableView(_ foodSelectedTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        (_requiredMethodsDataSource ?? tableViewDataSourceNotSet).tableView(foodSelectedTableView, cellForRowAt: indexPath)
    }
}

#endif
