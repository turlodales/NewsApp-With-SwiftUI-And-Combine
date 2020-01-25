//
//  WeatherViewModel.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Алексей Воронов on 21.07.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import SwiftUI
import Combine

final class WeatherViewModel: ObservableObject {
    private let weatherService: WeatherServiceProtocol = WeatherService()
    
    private var bag = Set<AnyCancellable>()
    
    @Published private (set) var weather: WeatherResponse?
    
    var emptyWeather: WeatherResponse {
        return WeatherResponse(currently: Weather(time: Date(),
                                                  icon: .clearDay,
                                                  temperature: 0.0),
                               hourly: HourlyWeatherData(summary: "",
                                                         data: []),
                               daily: DailyWeatherData(data: []))
    }
    
    func getCurrentWeather() {
        weatherService.requestCurrentWeather()
            .decode(type: WeatherResponse.self, decoder: Container.weatherJSONDecoder)
            .replaceError(with: emptyWeather)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] weather in
                self?.weather = weather
            })
            .store(in: &bag)
    }
}
