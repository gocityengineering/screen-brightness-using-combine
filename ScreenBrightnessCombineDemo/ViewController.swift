//
//  ViewController.swift
//  ScreenBrightnessCombineDemo
//
//  Created by Ross Butler on 07/06/2022.
//

import UIKit

typealias UIKitScreenBrightnessService = UIKitScreenBrightnessService3

class ViewController: UIViewController {
    /// In production code you'd inject the view model into the view controller rather than instantiating it directly as below.
    private let viewModel: ViewModel = {
        let notificationPublisher = NotificationCenter.default
            .publisher(for: UIScreen.brightnessDidChangeNotification)
            .eraseToAnyPublisher()
        let screenBrightnessService = UIKitScreenBrightnessService(
            notificationPublisher: notificationPublisher,
            screenBrightness: UIScreen.main
        )
        return SimpleViewModel(screenBrightnessService: screenBrightnessService)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}

