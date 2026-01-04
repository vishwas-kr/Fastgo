//
//  KeyboardHeightHelper.swift
//  Fastgo
//
//  Created by vishwas on 12/26/25.
//

import SwiftUI
import Combine

final class KeyboardHeightHelper: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)

        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
    }
}
