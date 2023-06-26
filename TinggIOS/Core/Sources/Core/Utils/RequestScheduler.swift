//
//  RequestScheduler.swift
//  
//
//  Created by Abdulrasaq on 14/06/2023.
//

import Foundation
class RequestScheduler: Schedular {
    var method: (() -> Void)?
    
    var timer: Timer?
    
    var timeInterval: TimeInterval?
    
    func setTimeInterval(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func getTimeInterval() -> TimeInterval {
        self.timeInterval!
    }
    
    func startScheduledRequest() {
        timer = Timer.scheduledTimer(withTimeInterval: getTimeInterval(), repeats: true) { timer in
                
        }
    }
    
    func stopScheduledRequest() {
        timer?.invalidate()
        timer = nil
    }
    

}

protocol Schedular {
    var timer: Timer? { get set }
    var timeInterval: TimeInterval? { get set }
    var method: (() -> Void)? { get set }
    func setTimeInterval(timeInterval: TimeInterval)
    func getTimeInterval() -> TimeInterval
    func startScheduledRequest()
    func stopScheduledRequest()
    
}

public class AppScheduler  {
    private var timeInterval: TimeInterval
    private var timer: Timer?
    private var method: (() async -> Void)
    private init(timeInterval: TimeInterval, method: @escaping () async -> Void) {
        self.timeInterval = timeInterval
        self.method = method
    }
    public class Builder {
        private var timeInterval: TimeInterval?
        private var timer: Timer?
        private var method: (() async -> Void)?
        public init() {
            //
        }
        public func setTimeInterval(time: TimeInterval) -> Builder {
            timeInterval = time
            return self
        }
        public func setRequest(call: @escaping () async -> Void) -> Builder  {
            method = call
            return self
        }

        public func build() -> AppScheduler {
            return  AppScheduler(timeInterval: timeInterval!, method: method!)
        }
//        public func start() -> Builder {
//            AppScheduler(timeInterval: timeInterval!, method: method!).startScheduledRequest()
//            return self
//        }
//        public func stop() -> Builder {
//            AppScheduler(timeInterval: timeInterval!, method: method!).stopScheduledRequest()
//            return self
//        }
    }
    public func startScheduledRequest() -> AppScheduler {
        Log.d(message: "Scheduler started")
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            Task {
                await self.method()
            }
        }
        return self
    }
    
    public func stopScheduledRequest() {
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopScheduledRequest()
    }
}
