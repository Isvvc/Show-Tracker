//
//  SeriesDetailViewController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol SeriesDetailDelegate {
    func seriesWasCreated(series: Series)
    func seriesWasEdited(from oldSeries: Series, to newSeries: Series)
}

class SeriesDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfSeasonsStepper: UIStepper!
    @IBOutlet weak var numberOfSeasonsLabel: UILabel!
    @IBOutlet weak var viewerCurrentEpisodeTextField: UITextField!
    @IBOutlet weak var viewerCurrentSeasonStepper: UIStepper!
    @IBOutlet weak var viewerCurrentSeasonLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var episodeLengthTextField: UITextField!
    
    //MARK: Properties
    
    var series: Series?
    var delegate: SeriesDetailDelegate?
    var seasonsList: [Int?] = []
    
    //MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SeriesDetailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        nameTextField.delegate = self
        
        if let series = series {
            nameTextField.text = series.name
            numberOfSeasonsStepper.value = Double(series.episodesInExistingSeason.count)
            seasonsList = series.episodesInExistingSeason
            viewerCurrentEpisodeTextField.text = String(series.viewerCurrentEpisode)
            viewerCurrentSeasonStepper.value = Double(series.viewerCurrentSeason + 1)
            episodeLengthTextField.text = String(series.averageEpisodeLength)
        }
        
        updateViews()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    @IBAction func numberOfSeasonsChanged(_ sender: UIStepper) {
        updateViews()
    }
    
    @IBAction func viewerCurrentSeasonChanged(_ sender: UIStepper) {
        updateViews()
    }
    
    //MARK: Private
    
    private func updateViews() {
        numberOfSeasonsLabel.text = String(Int(numberOfSeasonsStepper.value))
        viewerCurrentSeasonStepper.maximumValue = numberOfSeasonsStepper.value
        viewerCurrentSeasonLabel.text = String(Int(viewerCurrentSeasonStepper.value))
        dismissKeyboard()
    }
    
    private func updateSeasons() {
        let numberOfSeasons = Int(numberOfSeasonsStepper.value)
        if seasonsList.count > numberOfSeasons {
            // Remove extra seasons off the end of the list
            repeat {
                seasonsList.removeLast()
            } while seasonsList.count != numberOfSeasons
        } else if seasonsList.count < numberOfSeasons {
            // Add blank seasons to the end of the array
            repeat {
                seasonsList.append(nil)
            } while seasonsList.count != numberOfSeasons
        }
    }
    
    private func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seasonListVC = segue.destination as? SeasonListTableViewController,
            segue.identifier == "SeasonsShowSegue" {
            updateSeasons()
            seasonListVC.delegate = self
        }
    }
    
    //MARK: Actions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
            let viewerCurrentEpisodeString = viewerCurrentEpisodeTextField.text,
            let viewerCurrentEpisode = Int(viewerCurrentEpisodeString),
            let episodeLengthString = episodeLengthTextField.text,
            let episodeLength = Int(episodeLengthString) else {
                showAlert(title: "Could not save show", message: "Please fill out all forms.")
                return
        }
        
        updateSeasons()
        let viewerCurrentSeason = Int(viewerCurrentSeasonStepper.value) - 1
        
        guard let viewerCurrentSeasonEpisodes = seasonsList[viewerCurrentSeason] else {
            showAlert(title: "Could not save show", message: "Current season has no episodes.")
            return
        }
        
        print(viewerCurrentEpisode)
        print(viewerCurrentSeasonEpisodes)
        guard viewerCurrentEpisode <= viewerCurrentSeasonEpisodes else {
            showAlert(title: "Could not save show", message: "Current episode (\(viewerCurrentEpisode)) is greater than the total number of episodes in Season \(viewerCurrentSeason + 1) (\(viewerCurrentSeasonEpisodes))")
            return
        }
        
        let newSeries = Series(name: name, episodesInExistingSeason: seasonsList, averageEpisodeLength: episodeLength, viewerCurrentSeason: viewerCurrentSeason, viewerCurrentEpisode: viewerCurrentEpisode)
        
        if let series = self.series {
            delegate?.seriesWasEdited(from: series, to: newSeries)
        } else {
            delegate?.seriesWasCreated(series: newSeries)
        }
    }
}

extension SeriesDetailViewController: SeasonListDelegate {
    func setSeason(index seasonIndex: Int, to number: Int) {
        seasonsList[seasonIndex] = number
    }
    
    var seasons: [Int?] {
        get {
            return seasonsList
        }
    }
}
