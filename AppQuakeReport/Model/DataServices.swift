//
//  DataServices.swift
//  AppQuakeReport
//
//  Created by admin on 5/26/20.
//  Copyright © 2020 Long. All rights reserved.
//

import Foundation

typealias JSON = Dictionary<AnyHashable,Any>

class DataServices {
    static var share = DataServices()
    var urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    var quakeInfos : [QuakeInfo] = []
    var arrayDataDetail: [Any] = []
    var selectedQuake : QuakeInfo?
    
    // quá trình request api
    func makeDataTaskRequest(urlString: String, completedBlock: @escaping (JSON) -> Void) {
        // closure lưu lại giá trị trong completedBlock, có tham số đầu vào là json trả về void.
        // chuyển url string sang urlRequest.
        guard let url = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest(url: url,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: 10)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, reponse, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
                return
            }
            guard let json = jsonObject as? JSON else {
                return
            }
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
    }
    // lấy dữ liệu từ file json sau đó request
    func getDataQuake(completeHandle: @escaping ([QuakeInfo]) -> Void ) {
        // giá trị trả về lưu vào completeHandle.
        quakeInfos = [] // request giá trị quakeInfos sau mỗi lần load lại.
        makeDataTaskRequest(urlString: urlString) {
            [unowned self] json in
            // lấy file json ra sử dụng sau khi đã request về.
            guard let dictionaryFeatures = json["features"] as? [JSON] else  {
                return
            }
            for featureJSON in dictionaryFeatures {
                if let propertiesJSON = featureJSON["properties"] as? JSON {
                    if let quakeInfo = QuakeInfo(dict: propertiesJSON) {
                        self.quakeInfos.append(quakeInfo)
                    }
                }
            }
            // lưu mang quakeInfos vào completeHandle
            completeHandle(self.quakeInfos)
        }
    }
}




