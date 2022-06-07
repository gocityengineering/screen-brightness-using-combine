//
//  ScreenBrightnessService2.swift
//  ScreenBrightnessCombineDemo
//
//  Created by Ross Butler on 07/06/2022.
//

import Combine
import Foundation
import UIKit

protocol ScreenBrightness: AnyObject {
    var brightness: CGFloat { get set }
}

extension UIScreen: ScreenBrightness {}

protocol ScreenBrightnessService2 {
    var publisher: ScreenBrightnessPublisher { get }
    func set(to value: Double)
}

class UIKitScreenBrightnessService2: ScreenBrightnessService2 {
    let publisher: ScreenBrightnessPublisher // i.e. AnyPublisher<Double, Never>
    private let screenBrightness: ScreenBrightness
    
    init(notificationPublisher: AnyPublisher<Notification, Never>, screenBrightness: ScreenBrightness) {
        publisher = notificationPublisher
            .map { _ -> Double in
                return screenBrightness.brightness // Swift 5.5 automatically converts between CGFloat and Double.
            }
            .eraseToAnyPublisher()
        self.screenBrightness = screenBrightness
    }
    
    func set(to value: Double) {
        screenBrightness.brightness = value
    }
}
