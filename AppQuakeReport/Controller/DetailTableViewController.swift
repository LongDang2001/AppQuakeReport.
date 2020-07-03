//
//  DetailTableViewController.swift
//  AppQuakeReport
//
//  Created by admin on 5/27/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit
// MARK: -mark
class DetailTableViewController: UITableViewController {
    
    enum CellType: Int {
        case mag
        case time
        case depth
        case latitude
        case longitude
        case felt
        case cdi
        case mmi
        case alert
        case place

        func needToShow(dataDetail: QuakeInfo?) -> Bool {
            switch self {
            case .mag:
                return dataDetail?.mag != nil
            case .place:
                return !checkStringisNullOrEmpty(string:dataDetail?.distanceString) || !checkStringisNullOrEmpty(string:dataDetail?.locationName)
            case .time:
                return !checkStringisNullOrEmpty(string: dataDetail?.eventTime)
            case .depth:
                return !checkStringisNullOrEmpty(string: dataDetail?.depth)
            case .latitude:
                return !checkStringisNullOrEmpty(string: dataDetail?.latitude)
            case .longitude:
                return !checkStringisNullOrEmpty(string: dataDetail?.longitude)
            case .felt:
                return dataDetail?.felt != nil
            case .cdi:
                return dataDetail?.cdi != nil
            case .mmi:
                return dataDetail?.mmi != nil
            case .alert:
                return !checkStringisNullOrEmpty(string: dataDetail?.alert)
            }
            
        }
        
        private func checkStringisNullOrEmpty(string: String?) -> Bool {
            guard let aString = string else {return true}
            if aString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // cat di nhung ki tu trong whitespacesAndNewlines roi kiem tra trong
                return true
            }
            return false
        }
    }
    
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var evenTimeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var feltLabel: UILabel!
    @IBOutlet weak var cdiLabel: UILabel!
    @IBOutlet weak var mmiLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    
    var dataDetail: QuakeInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        DataServices.share.selectedQuake?.loadDataDetail { [unowned self] quakeInfo in
            self.dataDetail = quakeInfo
            
            self.magLabel.text = "Mag: \(self.dataDetail!.mag)"
            self.placeLabel.text = "Place: \(self.dataDetail!.distanceString) \(self.dataDetail!.locationName)"
            
            if let eventime = self.dataDetail?.eventTime {
                self.evenTimeLabel.text = "Even Time: \(eventime)"
            }
            if let depth = self.dataDetail?.depth {
                self.depthLabel.text = "Depth: \(depth)"
            }
            if let latitude = self.dataDetail?.latitude {
                self.latitudeLabel.text = "Latitude: \(latitude)"
            }
            
            if let longitude = self.dataDetail?.longitude {
                self.longitudeLabel.text = "Longitude: \(longitude)"
            }
            if let felt = self.dataDetail?.felt {
                self.feltLabel.text = "Felt: \(felt)"
            }
            if let cdi = self.dataDetail?.cdi {
                self.cdiLabel.text = "Cdi: \(cdi)"
            }
            if let mmi = self.dataDetail?.mmi {
                self.mmiLabel.text = "Mmi: \(mmi)"
            }
            self.alertLabel.text = "Alert: \(self.dataDetail?.alert ?? "")"
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellType = CellType(rawValue: indexPath.row) {
            return cellType.needToShow(dataDetail: dataDetail) ? UITableView.automaticDimension : 0
        } else {
            return 0
        }
    }
}
