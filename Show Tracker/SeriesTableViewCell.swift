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
    
    var seriesController: SeriesController?
    var index: Int?{
        didSet {
            guard let seriesController = seriesController else { return }
            currentEpisodeStepper.value = Double(seriesController.seriesList[index!].viewerCurrentEpisode)
            currentEpisodeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: currentEpisodeLabel!.font.pointSize, weight: .regular)
            updateViews()
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    //MARK: Private
    private func updateViews() {
        guard let index = index,
            let seriesController = seriesController else { return }
        let series = seriesController.seriesList[index]
        nameLabel.text = series.name
        
        currentEpisodeLabel.text = "On: S\(series.viewerCurrentSeason + 1)E\(Int(currentEpisodeStepper.value))"
        
        var episodesToWatch = 0
        var i = 0
        for season in series.episodesInExistingSeason {
            if series.viewerCurrentSeason == i {
                if let number = season {
                    episodesToWatch += number - (series.viewerCurrentEpisode - 1)
                }
            } else if series.viewerCurrentSeason < i {
                if let number = season {
                    episodesToWatch += number
                }
            }
            i += 1
        }
        let watchTime = Int(round(Double(episodesToWatch * series.averageEpisodeLength) / 60))
        let dateText = dateFormatter.string(from: series.nextSeasonDate)
        watchTimeLabel.text = "About \(watchTime) hours to watch \(episodesToWatch) episodes by \(dateText)."
    }
    
    @IBAction func currentEpisodeChanged(_ sender: UIStepper) {
        guard let index = index,
            let seriesController = seriesController else { return }
        //var series = seriesController.seriesList[index]
        seriesController.seriesList[index].viewerCurrentEpisode = Int(currentEpisodeStepper.value)
        updateViews()
    }
}
