//
//  SeasonListTableViewController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol SeasonListDelegate {
    var seasons: [Int?] { get }
    func setSeason(index seasonIndex: Int, to number: Int)
}

class SeasonListTableViewController: UITableViewController {
    
    var delegate: SeasonListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let seasonCount = delegate?.seasons.count {
            return seasonCount
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as? SeasonTableViewCell else { return UITableViewCell() }

        cell.delegate = delegate
        cell.index = indexPath.row

        return cell
    }

}
