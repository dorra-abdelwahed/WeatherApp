//
//  AdressTableViewCell.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import UIKit

class AdressTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    var lat, lon: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(adress: SearchResultResponse){
        titleLbl.text = adress.name ?? ""
        subTitleLbl.text = adress.state ?? ""
        lat = adress.lat
        lon = adress.lon
    }
    
}
