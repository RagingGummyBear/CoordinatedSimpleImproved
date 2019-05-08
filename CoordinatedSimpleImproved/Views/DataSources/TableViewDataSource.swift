//___FILEHEADER___

import Foundation
import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void

    public var models: [Model]

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )

        cellConfigurator(model, cell)
        return cell
    }
}

extension TableViewDataSource where Model == ExampleModel {
    static func make(for models: [ExampleModel],
                     reuseIdentifier: String = "ExampleModelDataCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: models,
            reuseIdentifier: reuseIdentifier
        ) { (model, cell) in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.description
        }
    }
}

extension TableViewDataSource where Model == UserModel {
    static func make(for models: [UserModel],
                     reuseIdentifier: String = "UserModelCells") -> TableViewDataSource {
        return TableViewDataSource(
            models: models,
            reuseIdentifier: reuseIdentifier
        ) { (model, cell) in
            cell.textLabel?.text = model.username
            cell.detailTextLabel?.text = model.name
        }
    }
}

extension TableViewDataSource where Model == ToDoModel {
    static func make(for models: [ToDoModel],
                     reuseIdentifier: String = "TODOModelCells") -> TableViewDataSource {
        return TableViewDataSource(
            models: models,
            reuseIdentifier: reuseIdentifier
        ) { (model, cell) in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(model.completed!)"
        }
    }
}
