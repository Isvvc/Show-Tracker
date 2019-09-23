//
//  SeriesDetailViewController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SeriesDetailViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: Properties
    
    var series: Series?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
    }
}
