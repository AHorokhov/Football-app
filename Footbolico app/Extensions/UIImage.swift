//
//  UIImage.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 26.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

extension UIImageView {

    enum PossibleIconDimensions: String {
        case small = "?rule=clip-32x32"
        case medium = "?rule=clip-56x56"
        case large = "?rule=clip-112x112"
    }

    func load(url: String, dimension: PossibleIconDimensions) {
        DispatchQueue.global().async { [weak self] in
            let urlString = url + dimension.rawValue
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
