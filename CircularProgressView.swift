// File: CircularProgressView.swift

import SwiftUI

struct CircularProgressView: View {
    let progress: Double // 0.0 – 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 14)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.cyan,
                            Color.blue,
                            Color.indigo,
                            Color.cyan
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
        }
    }
}

