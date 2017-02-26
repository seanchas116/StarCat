import UIKit
import Wirework

class WWTableViewDelegate: WWScrollViewDelegate, UITableViewDelegate {
    private let _itemSelected = Event<IndexPath>()
    
    var itemSelected: Signal<IndexPath> { return _itemSelected }
    
    override init() {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _itemSelected.emit(indexPath)
    }
}

class WWTableViewDataSource<Element>: NSObject, UITableViewDataSource {
    var elements = [Element]()
    let cellIdentifier: String
    private let _bind: (Int, Element, UITableViewCell) -> Void
    
    init(cellIdentifier: String, bind: @escaping (Int, Element, UITableViewCell) -> Void) {
        self.cellIdentifier = cellIdentifier
        _bind = bind
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        _bind(indexPath.row, elements[indexPath.row], cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension UITableView {
    override var wwDelegate: WWTableViewDelegate {
        return installDelegate { WWTableViewDelegate() }
    }
    
    public var wwItemSelected: Signal<IndexPath> {
        return wwDelegate.itemSelected
    }
    
    public func wwRows<C: Collection>(_ cellIdentifier: String, bind: @escaping (Int, C.Iterator.Element, UITableViewCell) -> Void) -> (C) -> Void {
        let dataSource = WWTableViewDataSource<C.Generator.Element>(cellIdentifier: cellIdentifier, bind: bind)
        self.dataSource = dataSource
        return { [weak self] collection in
            dataSource.elements = Array(collection)
            self?.reloadData()
        }
    }
}
