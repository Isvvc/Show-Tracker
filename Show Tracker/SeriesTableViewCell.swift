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
            updateViews()
        }
    }
//    var series: Series? {
//        didSet {
//            currentEpisodeStepper.value = Double(series!.viewerCurrentEpisode)
//            updateViews()
//        }
//    }
    
    //MARK: Private
    private func updateViews() {
        guard let index = index,
            let seriesController = seriesController else { return }
        let series = seriesController.seriesList[index]
        nameLabel.text = series.name
        
        currentEpisodeLabel.text = "On episode: \(Int(currentEpisodeStepper.value))"
        
        var episodesToWatch = 0
        var i = 0
        for season in series.episodesInExistingSeason {
            if series.viewerCurrentSeason - 1 == i {
                if let number = season {
                    episodesToWatch += number - (series.viewerCurrentEpisode - 1)
                }
            } else if series.viewerCurrentSeason - 1 < i {
                if let number = season {
                    episodesToWatch += number
                }
            }
            i += 1
        }
        let watchTime = Int(round(Double(episodesToWatch * series.averageEpisodeLength) / 60))
        watchTimeLabel.text = "\(watchTime) hours to watch \(episodesToWatch) episodes by date."
    }
    
    @IBAction func currentEpisodeChanged(_ sender: UIStepper) {
        guard let index = index,
            let seriesController = seriesController else { return }
        //var series = seriesController.seriesList[index]
        seriesController.seriesList[index].viewerCurrentEpisode = Int(currentEpisodeStepper.value)
        updateViews()
    }
}
