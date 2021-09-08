//
//  CurrentLocationCell.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//

import UIKit

class CurrentLocationCell: UITableViewCell {

    @IBOutlet weak var currentLocationImage : UIImageView!
    @IBOutlet weak var currentLocationLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
