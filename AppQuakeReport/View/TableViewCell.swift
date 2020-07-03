//
//  TableViewCell.swift
//  AppQuakeReport
//
//  Created by admin on 7/2/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func prepareForReuse() {
        magLabel.text = ""
        distanceLabel.text = ""
        locationLabel.text = ""
        dateLabel.text = ""
        timeLabel.text = ""
    }

}

@IBDesignable
class CustomLabel: UILabel {
    private var _cornerRadius: CGFloat = 0.0

    @IBInspectable
    var cornerRadius: CGFloat {
        set (newValue) {
            _cornerRadius = newValue
            setCornerRadius()
        }
        get {
            return _cornerRadius
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    func setCornerRadius() {
        if _cornerRadius == -1 {
            layer.cornerRadius = frame.height * 0.5
        } else {
            layer.cornerRadius = _cornerRadius
        }
    }
}
