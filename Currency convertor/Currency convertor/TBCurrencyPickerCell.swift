//
//  TBCurrencyPickerCell.swift
//  Currency convertor
//
//  Created by Кирилл Володин on 15.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class TBCurrencyPickerCell: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
