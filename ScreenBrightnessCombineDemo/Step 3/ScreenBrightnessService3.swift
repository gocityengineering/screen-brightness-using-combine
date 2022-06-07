//
//  ScreenBrightnessService3.swift
//  ScreenBrightnessCombineDemo
//
//  Created by Ross Butler on 07/06/2022.
//

import Combine
import Foundation

protocol ScreenBrightnessService3 {
    var publisher: ScreenBrightnessPublisher { get }
    func set(to value: Double)
}

class UIKitScreenBrightnessService3: ScreenBrightnessService3 {
    private let brightnessSubject: CurrentValueSubject<Double, Never>
    private var cancellables = Set<AnyCancellable>()
    var publisher: ScreenBrightnessPublisher { // i.e. AnyPublisher<Double, Never>
        brightnessSubject.eraseToAnyPublisher()
    }

    private let screenBrightness: ScreenBrightness

    init(notificationPublisher: AnyPublisher<Notification, Never>, screenBrightness: ScreenBrightness) {
        brightnessSubject = CurrentValueSubject<Double, Never>(screenBrightness.brightness)
        self.screenBrightness = screenBrightness
        subscribe(to: notificationPublisher)
    }

    func set(to value: Double) {
        screenBrightness.brightness = value
    }

    private func subscribe(to notificationPublisher: AnyPublisher<Notification, Never>) {
        notificationPublisher
            .compactMap { [weak self] _ -> Double? in
                guard let self = self else {
                    return nil
                }
                return self.screenBrightness.brightness // Swift 5.5 automatically converts between CGFloat and Double.
            }
            .assign(to: \.brightnessSubject.value, on: self)
            .store(in: &cancellables)
    }
}

