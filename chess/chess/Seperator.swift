//
//  Seperator.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//

import Foundation
import SwiftUI

let lightGreyColor = Color(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, opacity: 1.0)

struct seperator: View {
    var body: some View {
        VStack {
            Divider().background(lightGreyColor)

        }.padding()
            .frame(height: 1, alignment: .center)
    }
}
