//
//  ViewModel.swift
//  ScreenBrightnessCombineDemo
//
//  Created by Ross Butler on 07/06/2022.
//

import Combine
import Foundation

typealias ScreenBrightnessService = ScreenBrightnessService3

protocol ViewModel {
    func viewDidAppear()
    func viewDidDisappear()
}

class SimpleViewModel: ViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var previousBrightness: Double?
    private let screenBrightnessService: ScreenBrightnessService
    
    init(screenBrightnessService: ScreenBrightnessService) {
        self.screenBrightnessService = screenBrightnessService
        subscribe(to: screenBrightnessService.publisher)
    }
    
    private func subscribe(to screenBrightness: ScreenBrightnessPublisher) {
        screenBrightness.filter { brightness in
            brightness != 1.0 // We're not interested in cases where brightness has been set to maximum.
        }
        .map { brightness -> Double? in
            brightness // Map to an optional so we can assign to the optional instance variable.
        }
        .assign(to: \.previousBrightness, on: self)
        .store(in: &cancellables)
    }
    
    func viewDidAppear() {
        screenBrightnessService.set(to: 1.0) // 1 is full brightness (values range 0 - 1).
    }

    func viewDidDisappear() {
        guard let previousBrightness = previousBrightness else {
            return
        }
        screenBrightnessService.set(to: previousBrightness)
    }
}
