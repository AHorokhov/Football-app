//
//  DetailsViewController.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 27.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet private weak var homeTeamIconImageView: UIImageView!
    @IBOutlet private weak var awayTeamIconImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var homeTeamNameLabel: UILabel!
    @IBOutlet private weak var awayTeamNameLabel: UILabel!
    @IBOutlet private weak var stadiumTitleLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var channelLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    private var selectedEventId: Int?
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let eventId = selectedEventId else { return }
        Manager.shared.fetchDetails(for: eventId)
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] event in
                guard let self = self, let event = event else { return }
                self.setupDetailsFor(event: event)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Public
    
    func updateWithEventId(id: Int) {
        selectedEventId = id
    }
    
    // MARK: Private
    
    private func setupDetailsFor(event: Event) {
        homeTeamIconImageView.load(url: event.homeTeam.logoUrl, dimension: .large)
        awayTeamIconImageView.load(url: event.awayTeam.logoUrl, dimension: .large)
        homeTeamNameLabel.text = event.homeTeam.name
        awayTeamNameLabel.text = event.awayTeam.name
        scoreLabel.text = "\(event.result["home"] ?? 0) - \(event.result["away"] ?? 0)"
        stadiumTitleLabel.text = event.venue?["name"]
        cityLabel.text = event.venue?["city"]
        statusLabel.text = event.status
        channelLabel.text = event.channel?.isEmpty == true ? "No Info" : event.channel
        setupDateLabelFor(event: event)
    }
    
    private func setupDateLabelFor(event: Event) {
        guard let date = event.startDate else {
            dateLabel.isHidden = true
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "hh:mm" : "dd MMM yyyy hh:mm"
        dateLabel.text = dateFormatter.string(from: date)
        dateLabel.backgroundColor = UIColor.systemGray4
        dateLabel.textColor = UIColor.white
    }
    
}
