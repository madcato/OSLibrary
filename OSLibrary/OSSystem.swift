//
//  OSSystem.swift
//  OSLibrary
//
//  Created by Daniel Vela on 08/08/16.
//  Copyright © 2016 veladan. All rights reserved.
//

import UIKit

class OSSystem {
    // When the mobile detects something near the display, turn off it
    func enableProximitySensor() {
        UIDevice.currentDevice().proximityMonitoringEnabled = true
    }
    // Disable proximity sensor
    func disableProximitySensor() {
        UIDevice.currentDevice().proximityMonitoringEnabled = false
    }
}