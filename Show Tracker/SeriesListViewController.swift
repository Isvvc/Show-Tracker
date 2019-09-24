//
//  SeriesListViewController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SeriesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let seriesController = SeriesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seriesDetailVC = segue.destination as? SeriesDetailViewController {
            seriesDetailVC.delegate = self
            if segue.identifier == "ViewSeriesShowSegue",
                let indexPath = tableView.indexPathForSelectedRow {
                // Placeholder code to fill in a generic series
                //seriesDetailVC.series = Series(name: "Houseki no Kuni", episodesInExistingSeason: [], averageEpisodeLength: 30, viewerCurrentSeason: 0, viewerCurrentEpisode: 0)
                seriesDetailVC.series = seriesController.seriesList[indexPath.row]
            }
        }
    }
    
    

}

extension SeriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesController.seriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
        // Placeholder code to fill in a generic series
        //let series = Series(name: "Houseki no Kuni", episodesInExistingSeason: [], averageEpisodeLength: 30, viewerCurrentSeason: 0, viewerCurrentEpisode: 0)
        let series = seriesController.seriesList[indexPath.row]
        print(series.name)
        cell.series = series
        return cell
    }
}

extension SeriesListViewController: SeriesDetailDelegate {
    func seriesWasCreated(series: Series) {
        seriesController.add(series: series)
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
    
    func seriesWasEdited(from oldSeries: Series, to newSeries: Series) {
        
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}
