//
//  EventTableViewCell.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 26.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

final class EventTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!

    @IBOutlet weak var homeTeamIconImage: UIImageView!
    @IBOutlet weak var awayTeamIconImage: UIImageView!

    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        homeTeamScoreLabel.text = nil
        awayTeamScoreLabel.text = nil
        homeTeamNameLabel.text = nil
        awayTeamNameLabel.text = nil
        homeTeamIconImage.image = nil
        awayTeamIconImage.image = nil
        timeLabel.text = nil
    }

}
