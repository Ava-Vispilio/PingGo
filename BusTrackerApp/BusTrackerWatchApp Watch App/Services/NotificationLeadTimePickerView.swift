//
//  NotificationLeadTimePickerView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//
// Reusable full-screen picker sheet for choosing lead time for notifications.

import SwiftUI

struct NotificationLeadTimePickerView: View {
    let maxLeadTime: Int
    @Binding var selectedMinutes: Int
    let onSet: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Notify me before arrival")
                .font(.headline)

            Picker("Minutes before", selection: $selectedMinutes) {
                ForEach(1...maxLeadTime, id: \.self) { minute in
                    Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                }
            }
            .labelsHidden()
            .frame(height: 100)

            Button("Set Timer") {
                onSet()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
