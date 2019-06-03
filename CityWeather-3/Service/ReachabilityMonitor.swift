//
//  ReachabilityMonitor.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/13/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityMonitor: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: ReachabilityMonitor = { return ReachabilityMonitor() }()
    
    override init() {
        super.init()
        
        reachability = Reachability()!
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        
    }
    
    static func stopNotifier() -> Void {
        do {
            try (ReachabilityMonitor.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isUnreachable(completed: @escaping (ReachabilityMonitor) -> Void) {
        if (ReachabilityMonitor.sharedInstance.reachability).connection == .none {
            completed(ReachabilityMonitor.sharedInstance)
        }
    }
}

