//
//  Series.swift
//  Show Tracker
//
//  Created by Isaac Lyons on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Series: Equatable, Codable {
    var name: String
    var episodesInExistingSeason: [Int?]
    var averageEpisodeLength: Int
    var viewerCurrentSeason: Int
    var viewerCurrentEpisode: Int
    var nextSeasonDate: Date
}
