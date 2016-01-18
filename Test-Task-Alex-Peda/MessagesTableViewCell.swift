//
//  MessagesTableViewCell.swift
//  Test-Task-Alex-Peda
//
//  Created by Alex Peda on 1/13/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    internal lazy var expandableLabel = UILabel()
    internal lazy var titleLabel = UILabel()
    
    internal var expanded: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.greenColor()
        
        expandableLabel.numberOfLines = 0
        expandableLabel.font = UIFont.systemFontOfSize(10)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
        
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        expandableLabel.preferredMaxLayoutWidth = CGRectGetWidth(expandableLabel.frame)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let views = [
            "expandableLabel": expandableLabel,
            "titleLabel": titleLabel
        ]
        
        self.contentView.removeConstraints(titleLabel.constraints)
        self.contentView.removeConstraints(expandableLabel.constraints)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        if expanded == true {
            self.contentView.addSubview(expandableLabel)
            expandableLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[expandableLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
            
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleLabel]-15-[expandableLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            expandableLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
            expandableLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        }
        else {
            expandableLabel.removeFromSuperview()
            
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
            titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        }
    }
}
