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
        cell.seriesController = seriesController
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            seriesController.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension SeriesListViewController: SeriesDetailDelegate {
    func seriesWasCreated(series: Series) {
        seriesController.add(series: series)
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
    
    func seriesWasEdited(from oldSeries: Series, to newSeries: Series) {
        seriesController.edit(from: oldSeries, to: newSeries)
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}
