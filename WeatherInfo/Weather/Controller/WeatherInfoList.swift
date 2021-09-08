//
//  WeatherInfoList.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//

import UIKit
import CoreData

class WeatherInfoList : UIViewController {
    
    @IBOutlet weak var tblList: UITableView!
    
    var objFiveDayForecastModel:CountryDataModel?
    var latitude : String? = "0"
    var longitude : String? = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        tblList.register(UINib(nibName: "WeatherListCell", bundle: .main), forCellReuseIdentifier: "WeatherListCell")
        tblList.delegate = self
        tblList.dataSource = self
        objFiveDayForecastModel = CountryDataModel()
        updataCountryList()
        objFiveDayForecastModel?.getCountryList(urlStr: "\(APIConstant.fiveDayForecast)\(latitude!)&lon=\(longitude!)&appid=\(APIConstant.apiKey)&units=metric")
        
        //        fetchRequest()
    }
    
    func updataCountryList(){
        objFiveDayForecastModel?.isDataLoaded = {(isViewLoaded) in
            DispatchQueue.main.async {
                self.tblList.reloadData()
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WeatherInfoList:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objFiveDayForecastModel?.arrList?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListCell", for: indexPath) as? WeatherListCell,objFiveDayForecastModel?.arrList?.list?.count ?? 0 > indexPath.row else{
            return UITableViewCell()
        }
        let objWeather = objFiveDayForecastModel?.arrList?.list?[indexPath.row]
        cell.lblRain.text = "Rain: \(objWeather?.weather?[0].description ?? "")"
        cell.lblWind.text = "Wind Speed: \(objWeather?.wind?.speed ?? 0)km/h"
        cell.lblHumidity.text = "Humidity: \(objWeather?.main?.humidity ?? 0)%"
        cell.lblTemperature.text = "Temperature: \(objWeather?.main?.temp ?? 0)°C"
        
        switch objWeather?.weather?[0].description?.lowercased() {
        case "light rain":
            cell.imgWeather.image = UIImage(named: "rainCloud")
        case "scattered clouds":
            cell.imgWeather.image = UIImage(named: "scatterCloud")
        case "clear sky":
            cell.imgWeather.image = UIImage(named: "clearCloud")
        case "broken cloud":
            cell.imgWeather.image = UIImage(named: "clearCloud")
        case "clearCloud":
            cell.imgWeather.image = UIImage(named: "clearCloud")
        default:
            cell.imgWeather.image = UIImage(named: "clearCloud")
        }
        
        var datee : String?
        datee = objWeather?.dt_txt
        // "2021-06-25T00:00:00Z"
        if let objDate = datee {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let showDate = inputFormatter.date(from: (objDate))
            inputFormatter.dateFormat = "MMM d, h:mm a"
            let resultString : String?
            if showDate != nil {
                resultString = inputFormatter.string(from: showDate!)
                cell.lblDate.text = resultString
            }else {
                cell.lblDate.text = objDate
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objFiveDayForecastModel?.heightForRowAtIndexPath() ?? 0
    }
}

