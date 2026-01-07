//
//  View.swift
//  Fastgo
//
//  Created by vishwas on 1/5/26.
//
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
