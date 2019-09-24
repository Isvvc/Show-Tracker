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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seriesDetailVC = segue.destination as? SeriesDetailViewController {
            if segue.identifier == "ViewSeriesShowSegue" {
                // Placeholder code to fill in a generic series
                seriesDetailVC.series = Series(name: "Houseki no Kuni", episodesInExistingSeason: [], averageEpisodeLength: 30, viewerCurrentSeason: 0, viewerCurrentEpisode: 0)
            }
        }
    }
    
    

}

extension SeriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
        // Placeholder code to fill in a generic series
        let series = Series(name: "Houseki no Kuni", episodesInExistingSeason: [], averageEpisodeLength: 30, viewerCurrentSeason: 0, viewerCurrentEpisode: 0)
        print(series.name)
        cell.series = series
        return cell
    }
}
