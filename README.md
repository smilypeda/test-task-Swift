# README #

Test task fully written in Swift

### External libs ###

* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner)
* [ECSlidingViewController](https://github.com/ECSlidingViewController/ECSlidingViewController)

### Notes ###
* Used next article for implementing flexible UITableView row height http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
* Set iOS 8 as deployment target because so we can use native Swift libs through Cocoapods (I mean SwiftyJSON, SwiftSpinner, Alamofire)
* Decided not to use .xib files for UITableViewCell subclasses because I think it's not good to keep them updated from both code and nibs. As we have some hacks related to table cells in this project (I mean expanding the height), it will be better for reading the sources to keep all the stuff in code only. From such a point, using xib seems to be additional complication of code

### Possible improvements ###

* Move Pods folder to .gitignore (a matter of taste)
* Writing tests for backend classes
* Make expanding animation smoother
* Use native UITableView instruments for expanding animation