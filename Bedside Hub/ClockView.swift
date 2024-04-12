//
//  ClockView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/4/24.
//

import SwiftUI


struct ClockView: View {
    @Binding var currentTime: String
    @Binding var currentSeconds: String
    let secondsEnabled: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            Text(currentTime)
                .font(.system(size: 160))
                .fontWeight(.light)
                .padding(.top, 1)
                .monospacedDigit()
                .foregroundColor(.white)
            if secondsEnabled {
                Text(currentSeconds)
                    .font(.system(size: 45))
                    .monospacedDigit()
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .padding(.vertical, 29)
            }
        }
    }
    

}

