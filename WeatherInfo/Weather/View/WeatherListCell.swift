//
//  WeatherInfoList.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//

import UIKit

class WeatherListCell : UITableViewCell {

        
    @IBOutlet weak var vwContentCell: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblRain: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        vwContentCell.layer.cornerRadius = 5.0
        vwContentCell.layer.shadowRadius = 5.0
        vwContentCell.layer.shadowOpacity = 0.9
        vwContentCell.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
