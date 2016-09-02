//
//  MaterialView.swift
//  showcaseUp
//
//  Created by AceGod on 8/31/16.
//  Copyright © 2016 AceGod. All rights reserved.
//  Used to style my views

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        // Here we create the color and then you grab the CGColor property out of it
        // Thats how you create your shadow color.
        // shadowColor is a CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
