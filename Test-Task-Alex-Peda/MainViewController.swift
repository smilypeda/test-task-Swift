//
//  ViewController.swift
//  Test-Task-Alex-Peda
//
//  Created by Alex Peda on 1/12/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

import UIKit
import ECSlidingViewController
import SwiftSpinner

var token: dispatch_once_t = 0

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView = UITableView()
    private let messagesTableViewCellID = "MessagesTableViewCellID"
    
    private lazy var textPanelView = UILabel()
    
    private let textPanelHeight: CGFloat = 200.0
    private var textPanelHeigthConstraint: NSLayoutConstraint?
    
    private var messages: [Message] = []
    
    private var expandedRow: Int = NSIntegerMax

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Messages", comment: "")
        
        let views = [
            "tableView": tableView,
            "textPanelView": textPanelView
        ]
        
        // Bar button items
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "leftItemPressed:")
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "rightItemPressed:")
        self.navigationItem.rightBarButtonItem = rightItem
        
        // Table view
        tableView.registerClass(MessagesTableViewCell.self, forCellReuseIdentifier: messagesTableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top , relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        // Text Panel View
        textPanelView.backgroundColor = UIColor.lightGrayColor()
        textPanelView.numberOfLines = 0
        textPanelView.hidden = true
        textPanelView.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(textPanelView)
        textPanelView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[textPanelView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // Common constraints
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom , relatedBy: NSLayoutRelation.Equal, toItem: textPanelView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: textPanelView, attribute: NSLayoutAttribute.Bottom , relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        let textPanelHeigthConstraint = NSLayoutConstraint(item: textPanelView, attribute: NSLayoutAttribute.Height , relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        self.view.addConstraint(textPanelHeigthConstraint)
        self.textPanelHeigthConstraint = textPanelHeigthConstraint
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // added next code to viewDidAppear just show the progress even on a fast network
        if messages.count == 0 {
            SwiftSpinner.show(NSLocalizedString("Messages", comment: ""))
            MessagesService().loadMessages { (messages: [Message]?) -> () in
                if let validMessages = messages {
                    self.messages = validMessages
                    self.tableView.reloadData()
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    private func showTextPanelAnimated(show: Bool) {
        if let constraint = textPanelHeigthConstraint {
            
            if show {
                self.textPanelView.hidden = false
            }
            
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                constraint.constant = show ? self.textPanelHeight : 0.0
                self.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    
                    if !show {
                        self.textPanelView.hidden = true
                    }
            })
        }
    }
    
    // MARK: Actions
    
    private dynamic func leftItemPressed(sender: AnyObject) {
        let slidingViewController = self.slidingViewController()
        if (slidingViewController.currentTopViewPosition != ECSlidingViewControllerTopViewPosition.Centered) {
            slidingViewController.resetTopViewAnimated(true)
        }
        else {
            slidingViewController.anchorTopViewToRightAnimated(true)
        }
    }
    
    private dynamic func rightItemPressed(sender: AnyObject) {
        let viewController = UIViewController()
        viewController.title = NSLocalizedString("Empty Screen", comment: "")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MessagesTableViewCell = tableView.dequeueReusableCellWithIdentifier(messagesTableViewCellID) as! MessagesTableViewCell
        cell.expanded = (indexPath.row == expandedRow)
        
        let message = messages[indexPath.row]
        cell.titleLabel.text = message.id
        cell.expandableLabel.text = message.rawJSON
        
        // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.messagesTableViewCellID) as! MessagesTableViewCell
        cell.expanded = (indexPath.row == expandedRow)
        
        let message = messages[indexPath.row]
        cell.titleLabel.text = message.id
        cell.expandableLabel.text = message.rawJSON
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        cell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds))
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Get the actual height required for the cell
        var height: CGFloat = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        height += 1;
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.row]
        textPanelView.text = message.text
        updateExpandedRowWithIndexPath(indexPath)
        reloadTableAndScrollToIndexPath(indexPath)
    }
    
    private func updateExpandedRowWithIndexPath(indexPath: NSIndexPath) {
        if (expandedRow == indexPath.row) {
            expandedRow = NSIntegerMax
            showTextPanelAnimated(false)
        }
        else {
            expandedRow = indexPath.row
            showTextPanelAnimated(true)
        }
    }
    
    private func reloadTableAndScrollToIndexPath(indexPath: NSIndexPath) {
        UIView.transitionWithView(tableView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.tableView.reloadData()
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }, completion: {(finished) -> Void in
                
                // ensure that cell will be visible after expanding
                let cellRect = self.tableView.rectForRowAtIndexPath(indexPath)
                if self.tableView.bounds.contains(cellRect) == false {
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                }
        })
    }
}

