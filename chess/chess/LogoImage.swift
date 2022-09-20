//
//  logoImage.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//

import Foundation
import SwiftUI

struct LogoImage: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 40)
    }
}
