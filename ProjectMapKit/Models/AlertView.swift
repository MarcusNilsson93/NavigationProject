//
//  Alert.swift
//  ProjectMapKit
//
//  Created by Marcus Nilsson on 2020-03-13.
//  Copyright © 2020 Marcus Nilsson. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func showAlert(vc: UIViewController, with title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert,animated: true)
        }
        
    }
    static func errorPlacingPinAlert(vc: UIViewController){
        showAlert(vc: vc, with: "Couldn't place the pin", message: "Somting went wrong, please try again")
        
    }
    static func errorCalculatingRouteAlert(vc: UIViewController){
        showAlert(vc: vc, with: "Couldn't calculate the route", message: "Somting went wrong, please try again")
    }
    static func coreDataError(vc: UIViewController){
        showAlert(vc: vc, with: "Could not fetch the data", message: "The data could not be read, please try again")
    }
}
