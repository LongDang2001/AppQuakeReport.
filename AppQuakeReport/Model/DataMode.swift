//
//  DataMode.swift
//  AppQuakeReport
//
//  Created by admin on 5/26/20.
//  Copyright © 2020 Long. All rights reserved.
//

import Foundation

class QuakeInfo {
    // khai báo các thông số trên tableViewCell
    var timeString: String
    var dateString: String
    var distanceString: String
    var locationName: String
    var mag: Double
    //
    var url: String
    var detail: String
    // khai báo các thông tin trong json url.
    var felt:  Double?
    var mmi: Double?
    var cdi: Double?
    var alert: String?
    var eventTime: String?
    var latitude: String?
    var longitude: String?
    var depth: String?
    var hasDetails = false
    
    // khởi tạo các giá trị của thông tin của json
    init( mag: Double,  place: String, timeInterval: TimeInterval, url: String, detail: String) {
        self.mag = mag
        self.url = url
        self.detail = detail
        // tách các tên thành phố và vị trí trong string Place
        if place.contains(" of ") {
            let placeDetails = place.components(separatedBy: "of") // tách string place thành hai phần trước và sau of
            self.distanceString = (placeDetails.first ?? "") + "OF"
            self.locationName = placeDetails.last ?? ""
            
        } else {
            self.distanceString = "NEAR THE"
            self.locationName = place
        }
        // định dạng lại kiểu ngày tháng.
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        self.timeString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        self.dateString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
    }
    
    // what happened?, lấy các giá trị trong file tương ứng của các string
    convenience init?(dict: JSON) {
        guard let mag = dict["mag"] as? Double else {return nil}
        guard let place = dict["place"] as? String else { return nil}
        guard let timeInterval = dict["time"] as? TimeInterval else {return nil}
        guard let url = dict["url"] as? String else {return nil}
        guard let detail = dict["detail"] as? String else {return nil}
        self.init(mag: mag, place: place, timeInterval: timeInterval, url: url, detail: detail)
        
    }
    
    func loadDataDetail(completeHandler: @escaping (QuakeInfo) -> Void) {
        DataServices.share.makeDataTaskRequest(urlString: detail) { (dictDetail) in
            guard let dictProperties = dictDetail["properties"] as? JSON else {
                return
            }
            let felt = dictProperties["felt"] as? Double
            let cdi = dictProperties["cdi"] as? Double
            let mmi = dictProperties["mmi"] as? Double
            let alert = dictProperties["alert"] as? String
            self.felt = felt
            self.cdi = cdi
            self.mmi = mmi
            self.alert = alert
            guard let dictProducts = dictProperties["products"] as? JSON else {
                return
            }
            guard let arrayOrigin = dictProducts["origin"] as? [JSON] else {
                return
            }
            guard let dictPropertiesOfOrigin = arrayOrigin[0]["properties"] as? JSON else {
                return
            }
            if let eventTime = dictPropertiesOfOrigin["eventtime"] as? String  {
                var convertEventTime = eventTime
                convertEventTime = convertEventTime.replacingOccurrences(of: "T", with: "  ")
                convertEventTime = convertEventTime.components(separatedBy: ".").first!
                self.eventTime = convertEventTime + " (UTC)"
            }
            
            if let depth = dictPropertiesOfOrigin["depth"] as? String  {
                self.depth = depth + " Km"
            }
            
            // dổi toạ độ
            guard let latitude = dictPropertiesOfOrigin["latitude"] as? String else {
                return
            }
            guard let longitude = dictPropertiesOfOrigin["longitude"] as? String else {
                return
            }
            func convertCoordinate(latitude: String, longitude: String) {
               if let latitudeDouble = Double(latitude) {
                    self.latitude = String(format:"%.3f°%@", abs(latitudeDouble), latitudeDouble >= 0 ? "N" : "S")
                }
                if let longitudeDouble = Double(longitude) {
                    self.longitude = String(format:"%.3f°%@", abs(longitudeDouble), longitudeDouble >= 0 ? "E" : "W")
                }
            }
            convertCoordinate(latitude: latitude, longitude: longitude)
            completeHandler(self)
        }
    }
}

