//
//  ButtonWithBackground.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//

import Foundation
import SwiftUI

let lightblueColor = Color(red: 85.0 / 255.0, green: 84.0 / 255.0, blue: 166.0 / 255.0, opacity: 1.0)

struct buttonWithBackground: View {
    var btnText: String

    var body: some View {
        HStack {
            Text(btnText)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 140, height: 50)
                .background(lightblueColor)
                .clipped()
                .cornerRadius(5.0)
                .shadow(color: lightblueColor, radius: 5, x: 0, y: 5)
        }
    }
}
