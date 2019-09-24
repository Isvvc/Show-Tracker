//
//  SeriesDetailViewController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SeriesDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfSeasonsStepper: UIStepper!
    @IBOutlet weak var numberOfSeasonsLabel: UILabel!
    @IBOutlet weak var viewerCurrentEpisodeTextField: UITextField!
    @IBOutlet weak var viewerCurrentSeasonStepper: UIStepper!
    @IBOutlet weak var viewerCurrentSeasonLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: Properties
    
    var series: Series?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SeriesDetailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.delegate = self
        
        updateViews()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateViews() {
        numberOfSeasonsLabel.text = String(Int(numberOfSeasonsStepper.value))
        viewerCurrentSeasonLabel.text = String(Int(viewerCurrentSeasonStepper.value))
        dismissKeyboard()
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
}
