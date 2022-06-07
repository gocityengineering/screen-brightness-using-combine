//
//  ScreenBrightnessService1.swift
//  ScreenBrightnessCombineDemo
//
//  Created by Ross Butler on 07/06/2022.
//

import Combine
import Foundation
import UIKit

protocol ScreenBrightnessService1 {
    var publisher: ScreenBrightnessPublisher { get }
}

class UIKitScreenBrightnessService1: ScreenBrightnessService1 {
    let publisher: ScreenBrightnessPublisher // i.e. AnyPublisher<Double, Never>

    init() {
        publisher = NotificationCenter.default.publisher(for: UIScreen.brightnessDidChangeNotification)
            .map { _ -> Double in
                return UIScreen.main.brightness // Swift 5.5 automatically converts between CGFloat and Double.
            }
            .eraseToAnyPublisher()
    }
}
