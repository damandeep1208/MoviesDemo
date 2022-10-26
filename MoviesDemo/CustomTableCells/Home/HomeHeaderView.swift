//
//  HomeHeaderView.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit

class HomeHeaderView: UITableViewHeaderFooterView {

    static let height: CGFloat = 34

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var bgView: HomeHeaderView!
    @IBOutlet weak var lblHeaderTitle1: UILabel!
    @IBOutlet weak var lblHeaderTitle2: UILabel!
    
    func configureFor(type: HomePageSections) {
        self.lblHeaderTitle1.text = type.title1()
        self.lblHeaderTitle2.text = type.title2()
        self.lblHeaderTitle1.textColor = type.textColor()
        self.lblHeaderTitle2.textColor = type.textColor()
    }
}
