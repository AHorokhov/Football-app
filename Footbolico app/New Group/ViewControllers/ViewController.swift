//
//  ViewController.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 25.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// TODO: Whole dataSource and delegate could rewritten with using RxDataSources, but it will take more time.
// TODO: public properties could be changed to private and configures inside tableCell class


final class ViewController: UIViewController {
    
    // MARK: Properties
    
    private var disposeBag = DisposeBag()
    private let leaguesListRelay: BehaviorRelay<[League]> = BehaviorRelay(value: [])
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataForTable()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Private
    
    private func fetchDataForTable() {
        Manager.shared.fetchData()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] leagues in
                guard let self = self, let leagues = leagues else { return }
                self.leaguesListRelay.accept(leagues)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setup(cell: EventTableViewCell, event: Event) -> EventTableViewCell {
        cell.homeTeamScoreLabel.text = "\(event.result["home"] ?? 0)"
        cell.awayTeamScoreLabel.text = "\(event.result["away"] ?? 0)"
        cell.homeTeamIconImage.load(url: event.homeTeam.logoUrl, dimension: .small)
        cell.awayTeamIconImage.load(url: event.awayTeam.logoUrl, dimension: .small)
        cell.homeTeamNameLabel.text = event.homeTeam.name
        cell.awayTeamNameLabel.text = event.awayTeam.name
        cell.timeLabel.text = convertDateToString(date: event.startDate)
        return cell
    }
    
    private func convertDateToString(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
}


// MARK: UITableViewDataSource and UITableViewDelegate

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaguesListRelay.value[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
        let event = leaguesListRelay.value[indexPath.section].events[indexPath.row]
        return setup(cell: cell, event: event)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return leaguesListRelay.value.count
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVC = UIStoryboard(name: "Details", bundle: nil)
            .instantiateViewController(withIdentifier: "details") as? DetailsViewController else { return }
        let eventId = leaguesListRelay.value[indexPath.section].events[indexPath.row].identifier
        detailsVC.updateWithEventId(id: eventId)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 40)))
        headerView.backgroundColor = UIColor.systemGray3
        
        let frame = CGRect.zero
        let imageView = UIImageView(frame: frame)
        let label = UILabel(frame: frame)
        imageView.load(url: leaguesListRelay.value[section].logoUrl, dimension: .medium)
        label.text = leaguesListRelay.value[section].name
        [imageView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
            $0.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        }
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        
        return headerView
    }
}

