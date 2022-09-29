//
//  UITableView+Extension.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import UIKit

extension UITableView {
    func register<Cell: UITableViewCell>(cellNibType: Cell.Type) {
        let cellClassName = String(describing: cellNibType.self)
        let nib = UINib(nibName: cellClassName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClassName)
    }
    
    func register<Cell: UITableViewCell>(cellType: Cell.Type) {
        let cellClassName = String(describing: cellType.self)
        register(cellType, forCellReuseIdentifier: cellClassName)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let cellClassName = String(describing: cellType.self)
        let cell = dequeueReusableCell(withIdentifier: cellClassName, for: indexPath)
        guard let typedCell = cell as? Cell else { fatalError("Could not deque cell with type \(Cell.self)") }
        return typedCell
    }
}
