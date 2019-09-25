//
//  SeriesController.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class SeriesController {
    
    init() {
        loadFromPersistentStore()
    }
    
    var seriesList: [Series] = []
    
    func add(series: Series) {
        seriesList.append(series)
        saveToPersistentStore()
    }
    
    func edit(from oldSeries: Series, to newSeries: Series) {
        guard let index = seriesList.firstIndex(of: oldSeries) else { return }
        seriesList[index] = newSeries
        saveToPersistentStore()
    }
    
    var seriesListURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documents.appendingPathExtension("SeriesList.plist")
    }
    
    func saveToPersistentStore() {
        guard let url = seriesListURL else { return }
        let encoder = PropertyListEncoder()
        
        do {
            let seriesData = try encoder.encode(seriesList)
            try seriesData.write(to: url)
        } catch {
            print("Error saving series data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        do {
            guard let url = seriesListURL else { return }
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedSeries = try decoder.decode([Series].self, from: data)
            seriesList = decodedSeries
        } catch {
            print("Error loading series data: \(error)")
        }
    }
}
