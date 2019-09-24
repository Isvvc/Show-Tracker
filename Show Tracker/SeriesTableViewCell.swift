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
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var currentEpisodeLabel: UILabel!
    @IBOutlet weak var currentEpisodeStepper: UIStepper!
    
    //MARK: Properties
    var series: Series? {
        didSet {
            currentEpisodeStepper.value = Double(series!.viewerCurrentEpisode)
            updateViews()
        }
    }
    
    //MARK: Private
    private func updateViews() {
        guard let series = series else { return }
        nameLabel.text = series.name
        
        currentEpisodeLabel.text = "On episode: \(Int(currentEpisodeStepper.value))"
        
        var episodesToWatch = 0
        var index = 0
        for season in series.episodesInExistingSeason {
            if series.viewerCurrentSeason - 1 == index {
                if let number = season {
                    episodesToWatch += number - (series.viewerCurrentEpisode - 1)
                }
            } else if series.viewerCurrentSeason - 1 < index {
                if let number = season {
                    episodesToWatch += number
                }
            }
            index += 1
        }
        let watchTime = Int(round(Double(episodesToWatch * series.averageEpisodeLength) / 60))
        watchTimeLabel.text = "\(watchTime) hours to watch \(episodesToWatch) episodes by date."
    }
    
    @IBAction func currentEpisodeChanged(_ sender: UIStepper) {
        series?.viewerCurrentEpisode = Int(currentEpisodeStepper.value)
        updateViews()
    }
}
