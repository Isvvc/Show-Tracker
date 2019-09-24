//
//  SeasonTableViewCell.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    var delegate: SeasonListDelegate?
    var index: Int? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        if let index = index {
            nameLabel.text = "Season \(index + 1)"
            if let number = delegate?.seasons[index] {
                numberTextField.text = String(number)
            }
        }
    }

    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        guard let index = index,
            let numberString = numberTextField.text,
            let number = Int(numberString) else { return }
        
        print("Setting Season \(index) to \(number).")
        delegate?.setSeason(index: index, to: number)
    }
}
