# Wirework

Wirework is a simple reactive programming & data binding utility for Swift.

## Features

* Simple reactive programming using signals and properties
  * Signals - abstraction of events
  * Properties - values that change reactively
* Extensions for UIKit
  * Listen events as signals
  * Bind data from properties
* TODO: support AppKit / WatchKit

###  Features Wirework do NOT provide

To be simple, easy and focused to UI data binding, Wirework won't provide some features that other Swift reactive programming frameworks have.

* Concurrency
* Versatile stream operations

## Install

TODO

## Feature Detail

### Signal

`Signal` represents events or signals. You can transform, merge or subscribe values Signals emits.

For simplicity, Signals are always stateless. Unlike Reactive Extension streams, they don't end or fail and there is no distinction of hot and cold.

`Event` is a `Signal` subclass that represents signal sources. You can directly emit values from Events.

```swift
import Wirework

// A bag to store subscriptions
let bag = SubscriptionBag()

let ev = Event<String>()
// Signals can be mapped into another signal
let mapped: Signal<Int> = ev.map { $0.characters.count }

// Subscribing signal
var received = [Int]()
mapped.subscribe {
    received.append($0)
}.addTo(bag)

// Emitting events!
ev.emit("foo")
ev.emit("bar")
ev.emit("quux")

received //=> [3, 3, 4]
```

### Property

`Property` represents values that change reactively. You can map or combine properties and subscribe their changes.

`Variable` is a `Property` subclass that represents mutable values. You can directly change values of Variables.

```swift
let bag = SubscriptionBag()

let text = Variable("foo")
let length: Property<Int> = foo.map { $0.characters.count }

// Subscribing change signal
var received = [Int]()
length.changed.subscribe {
    received.append($0)
}.addTo(bag)

// `length` updates its value over time
length.value //=> 3
text.value = "hogehoge"
length.value //=> 8

received //=> [8]
```

### Foundation extensions

#### NSNotificationCenter

```swift
let bag = SubscriptionBag()

let obj = NSObject()

// get signal for notification
let signal = NSNotificationCenter.defaultCenter()
  .wwNotification("test", object: obj)

// emit signal
NSNotificationCenter.defaultCenter()
  .postNotificationName("test", object: obj, userInfo: ["value": "foobar"])
```

### UIKit extensions

#### UIButton

```swift
import WireworkUIKit

let bag = SubscriptionBag()

let button = UIButton()
let title = Variable("Tap me")

// bind `title` value to button title
title.bindTo(button.wwState(.Selected).title).addTo(bag)
button.titleForState(.Normal)) //=> "Tap me"

title.value = "Don't tap me"

button.titleForState(.Normal)) //=> "Don't tap me"

// subscribe to tapped signal
var tapped = false
button.wwTapped.subscribe {
    tapped = true
}.addTo(bag)

// emulate tapping
button.sendActionsForControlEvents(.TouchUpInside)

tapped //=> true
```

### UITableView

```swift
import WireworkUIKit

let bag = SubscriptionBag()

let tableView = UITableView(frame: CGRectMake(0, 0, 1000, 1000))
tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

// bind items to table view
let items = Variable(["foo", "bar", "baz"])
items.bindTo(tableView.wwRows("cell") { row, elem, cell in
    cell.textLabel?.text = "\(row): \(elem)"
}).addTo(bag)

// TableView looks like...
// - 0: foo
// - 1: bar
// - 2: baz
```
