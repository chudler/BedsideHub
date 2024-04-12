//
//  DateView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/18/24.
//

import SwiftUI

struct DateView: View {
    let currentDate: String
    var body: some View {
        Text(currentDate)
            .font(.system(size: 23))
            .fontWeight(.light)
            .foregroundColor(.white)
            .padding(.horizontal, 0)
    }
}
