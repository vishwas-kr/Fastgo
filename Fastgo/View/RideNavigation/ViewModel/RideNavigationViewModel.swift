//
//  RideNavigationViewModel.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//
import Foundation
import Combine

extension Notification.Name {
    static let qrScanSuccessful = Notification.Name("qrScanSuccessful")
}

class RideNavigationViewModel : ObservableObject {
    
    @Published var remainingSeconds: Int = 600 // 10 minutes
    @Published var timer: Timer?
    @Published var didScanQRSuccessfully: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeQRScanNotification()
    }
    
    var isTimerExpired: Bool {
        remainingSeconds <= 0
    }
    
    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d : %02d mins", minutes, seconds)
    }
    
    func startTimer() {
        stopTimer()
        remainingSeconds = 600
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        remainingSeconds = 600
    }
    
    private func observeQRScanNotification() {
        NotificationCenter.default.publisher(for: .qrScanSuccessful)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didScanQRSuccessfully = true
            }
            .store(in: &cancellables)
    }
    
    func resetQRScanStatus() {
        didScanQRSuccessfully = false
    }
    
    static func notifyQRScanSuccess() {
        NotificationCenter.default.post(name: .qrScanSuccessful, object: nil)
    }
}
