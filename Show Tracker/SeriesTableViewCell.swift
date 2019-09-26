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
        if let nextSeasonDate = series.nextSeasonDate {
            let dateText = dateFormatter.string(from: nextSeasonDate)
            watchTimeLabel.text = "About \(watchTime) hours to watch \(episodesToWatch) episodes by \(dateText)."
        } else {
            watchTimeLabel.text = "About \(watchTime) hours to watch \(episodesToWatch) episodes."
        }
        
        print(isLastSeasonOfSeries(season: series.viewerCurrentSeason, episodeList: series.episodesInExistingSeason))
        if Int(currentEpisodeStepper.value) == series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1 && isLastSeasonOfSeries(season: series.viewerCurrentSeason, episodeList: series.episodesInExistingSeason) {
            currentEpisodeStepper.maximumValue = Double(series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1)
        }
    }
    
    // MARK: Actions
    
    func isLastSeasonOfSeries(season: Int, episodeList: [Int?]) -> Bool {
        let nextSeason = nextValidSeason(after: season, episodeList: episodeList)
        return nextSeason == season
    }
    
    func nextValidSeason(after currentSeason: Int, episodeList: [Int?]) -> Int {
        var i = currentSeason + 1
        while i < episodeList.count {
            if episodeList[i] == nil {
                i += 1
                continue
            } else {
                return i
            }
        }
        return currentSeason
    }
    
    @IBAction func currentEpisodeChanged(_ sender: UIStepper) {
        guard let index = index,
            let seriesController = seriesController else { return }
        
        let series = seriesController.seriesList[index]
        
        if Int(currentEpisodeStepper.value) > series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1 {
            if !isLastSeasonOfSeries(season: series.viewerCurrentSeason, episodeList: series.episodesInExistingSeason) {
                let nextSeason = nextValidSeason(after: series.viewerCurrentSeason, episodeList: series.episodesInExistingSeason)
                seriesController.seriesList[index].viewerCurrentSeason = nextSeason
                currentEpisodeStepper.value = 1.0
            } else {
                currentEpisodeStepper.value = Double(series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1)
            }
        }
        
        seriesController.seriesList[index].viewerCurrentEpisode = Int(currentEpisodeStepper.value)
        seriesController.saveToPersistentStore()
        updateViews()
    }
}
