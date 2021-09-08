//
//  ServerCommunication.swift
//  AppypieDemoApp
//
//  Created by Mithilesh on 03/09/21.
//

import UIKit

class ServerCommunication: NSObject {
    
    class func getData(urlStr:String,success:@escaping(Any)->Void){
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                print("server error: \n \(error?.localizedDescription)")
            }
            else{
                if let data = data{
                    let jsonStr = String(data: data, encoding: .utf8)
                    print("response : \n \(jsonStr)")
                    DispatchQueue.main.async {
                        success(data)
                    }
                }
            }
        }
        task.resume()
    }
}
