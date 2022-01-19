//
//  FilterViewController.swift
//  SteamList
//
//  Created by Adam Bokun on 15.01.22.
//

import UIKit

class FilterViewController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var newsModel = FilterNews()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.filteredGames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: FilterCell.identifier) as? FilterCell
              else {
            return UITableViewCell()
        }
        let info = newsModel.filteredGames[indexPath.row]
        cell.titleLabel.text = info.name
        cell.checkmarkImageView.isHidden = !info.isEnabled
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsModel.filteredGames[indexPath.row].isEnabled.toggle()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
