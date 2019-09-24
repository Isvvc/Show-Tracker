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
    var row: Int? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        if let row = row {
            nameLabel.text = "Season \(row + 1)"
            if let number = delegate?.seasons[row] {
                numberTextField.text = String(number)
            }
        }
    }

    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        guard let row = row,
            let numberString = numberTextField.text,
            let number = Int(numberString) else { return }
        
        print("Setting Season \(row) to \(number).")
        //delegate?.seasons[row] = number
        delegate?.setSeason(index: row, to: number)
    }
}
