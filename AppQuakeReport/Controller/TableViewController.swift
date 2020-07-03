//
//  TableViewController.swift
//  AppQuakeReport
//
//  Created by admin on 7/2/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    var quakeInfos: [QuakeInfo] = []
    var filterQuake: [QuakeInfo] = []
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        updateUserInterface()
        
        // get data hiển thị lên tableView.
        DataServices.share.getDataQuake { quakeInfos in
            self.quakeInfos = quakeInfos
            
            self.filterQuake = quakeInfos
            
            // Search
            // khoi tao nut search
            self.searchController = UISearchController(searchResultsController: nil)
//            // Hiển thị thanh công cụ search
//            self.tableView.tableHeaderView = self.searchController.searchBar
            // Hiển thị kết quả, cập nhật kết quả tìm kiếm
            self.searchController.searchResultsUpdater = self
            // cho kích thước phù hợp
            self.searchController.searchBar.sizeToFit()
            // ẩn thanh điều hướng trong khi trình bày
            self.searchController.hidesNavigationBarDuringPresentation = false
            // Làm mờ nền trong khi trình bày
            self.searchController.dimsBackgroundDuringPresentation = false
            // Truyền sang mất nút search, Định nghĩa bối cảnh trình bày
            self.navigationItem.searchController = self.searchController
            // khi kéo thì moi hien nut search
            self.definesPresentationContext = true
            self.tableView.reloadData()
        }

    }
    // internet
    func updateUserInterface() {
        guard let status = Network.reachability?.status else {
            return
        }
        switch status {
        case .unreachable:
            view.backgroundColor = .white
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        
        }
        print("Reachability Summary")
        print("Status", status)
        print("HostName: ", Network.reachability?.hostName ?? "nil")
        print("Reachable: ", Network.reachability?.isReachable ?? "nil")
        print("Wifi: ", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    // search
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filterQuake = quakeInfos.filter { (item: QuakeInfo) -> Bool in
                return (item.locationName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
                
            }
        }else {
            filterQuake = quakeInfos
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterQuake.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCell", for: indexPath) as! TableViewCell
        cell.magLabel.text = String(describing: filterQuake[indexPath.row].mag)
        cell.distanceLabel.text = filterQuake[indexPath.row].distanceString
        cell.locationLabel.text = filterQuake[indexPath.row].locationName
        cell.dateLabel.text = filterQuake[indexPath.row].dateString
        cell.timeLabel.text = filterQuake[indexPath.row].timeString
        return cell
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toWebControler = segue.destination as? WebViewController {
            if let index = tableView.indexPathForSelectedRow {
                toWebControler.urlOfRow = filterQuake[index.row].url
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataServices.share.selectedQuake = filterQuake[indexPath.row]
    }

}
