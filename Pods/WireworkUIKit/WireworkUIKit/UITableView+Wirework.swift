import UIKit
import Wirework

class WWTableViewDelegate: WWScrollViewDelegate, UITableViewDelegate {
    private let _itemSelected = Event<NSIndexPath>()
    
    var itemSelected: Signal<NSIndexPath> { return _itemSelected }
    
    override init() {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _itemSelected.emit(indexPath)
    }
}

class WWTableViewDataSource<Element>: NSObject, UITableViewDataSource {
    var elements = [Element]()
    let cellIdentifier: String
    private let _bind: (Int, Element, UITableViewCell) -> Void
    
    init(cellIdentifier: String, bind: (Int, Element, UITableViewCell) -> Void) {
        self.cellIdentifier = cellIdentifier
        _bind = bind
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        _bind(indexPath.row, elements[indexPath.row], cell)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

extension UITableView {
    override var wwDelegate: WWTableViewDelegate {
        return installDelegate { WWTableViewDelegate() }
    }
    
    public var wwItemSelected: Signal<NSIndexPath> {
        return wwDelegate.itemSelected
    }
    
    public func wwRows<C: CollectionType>(cellIdentifier: String, bind: (Int, C.Generator.Element, UITableViewCell) -> Void) -> (C) -> Void {
        let dataSource = WWTableViewDataSource<C.Generator.Element>(cellIdentifier: cellIdentifier, bind: bind)
        self.dataSource = dataSource
        return { [weak self] collection in
            dataSource.elements = Array(collection)
            self?.reloadData()
        }
    }
}
