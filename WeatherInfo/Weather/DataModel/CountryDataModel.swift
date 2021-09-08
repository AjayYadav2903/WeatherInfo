//
//  WeatherInfoList.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//

import UIKit

class CountryDataModel: NSObject {
    
    var isDataLoaded:((Bool)->Void)?
   // var arrCountryList:[Country] = []
    
    var arrList: Json4Swift_Base?

    
    func getCountryList(urlStr:String){
        ServerCommunication.getData(urlStr: urlStr) { data in
            if let data = data as? Data{
                self.parseData(data: data)
            }
        }
    }
    
    func parseData(data:Data){
        do{
            arrList = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
            isDataLoaded?(true)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func heightForRowAtIndexPath()->CGFloat{
        return 160.0
    }
}
