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
        
        //print(nextValidSeason(after: series.viewerCurrentSeason, episodeList: series.episodesInExistingSeason))
        
        
        //Basic Pseudocode
        // if the stepper is greater than the number of episodes in the current season, then
        //   if there is a next season, then
        //     set episode to 1
        //     increment season
        //     if this is the last season
        //       cap the stepper to the number of episodes in the season
        //     end if
        //   else
        //     set the stepper back to the last episode and cap it
        //   end if
        // end if
        
        //Pseudocode accounting for any empty seasons
        // if the stepper is greater than the number of episodes in the current season, then
        //   set repeat index to the next season
        //   loop until repeat index exceeds the season count OR the repeat index's season is not nil
        //     increment repeat index
        //   end loop
        //
        //   if repeat index's season is not nil
        //     set episode to 1
        //     increment season
        //     loop until repeat index exceeds the season count OR a non-nil season is found
        //       if repeat index exceeds the season count, then
        //         cap the stepper to the number of episodes in the season
        //       end if
        //     end loop
        //   else if the repeat index exceeds the season count
        //     set the stepper back to the last episode and cap it
        //   end if
        // end if
        
//        if Int(currentEpisodeStepper.value) > series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 0 {
//            var i = series.viewerCurrentSeason + 1
//            while i < series.episodesInExistingSeason.count && series.episodesInExistingSeason[i] == nil {
//                i += 1
//            }
//            if i < series.episodesInExistingSeason.count - 1 && series.episodesInExistingSeason[i] != nil {
//                currentEpisodeStepper.value = 1.0
//                seriesController.seriesList[index].viewerCurrentSeason = i
//                // j will the last non-nil season
//                var j = series.episodesInExistingSeason.count - 1
//                while j > 0 && series.episodesInExistingSeason[j] == nil {
//                    j -= 1
//                }
//                // if the current season, i, is the last non-nil season, j
//                if i == j {
//                    currentEpisodeStepper.maximumValue = Double(series.episodesInExistingSeason[i]!)
//                }
//            } else if i >= series.episodesInExistingSeason.count {
//                currentEpisodeStepper.value = Double(series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1)
//                currentEpisodeStepper.maximumValue = Double(series.episodesInExistingSeason[series.viewerCurrentSeason] ?? 1)
//            }
//        }
        
        seriesController.seriesList[index].viewerCurrentEpisode = Int(currentEpisodeStepper.value)
        seriesController.saveToPersistentStore()
        updateViews()
    }
}
