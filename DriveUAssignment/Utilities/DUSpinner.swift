//
//  DUSpinner.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit

// MARK: - Show Spinner View
public class DUSpinner {

    public static let singleton = DUSpinner()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()

    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .white
    }

    func showIndicator() {
        DispatchQueue.main.async( execute: {
            if let rootWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                rootWindow.addSubview(self.blurImg)
                rootWindow.addSubview(self.indicator)
            }
        })
    }
    
    func hideIndicator() {
        DispatchQueue.main.async( execute:
            {
                self.blurImg.removeFromSuperview()
                self.indicator.removeFromSuperview()
        })
    }
}
