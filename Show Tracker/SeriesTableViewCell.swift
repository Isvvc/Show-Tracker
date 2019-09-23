//
//  SeriesTableViewCell.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: Properties
    var series: Series? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Private
    private func updateViews() {
        guard let series = series else { return }
        nameLabel.text = series.name
    }

}
