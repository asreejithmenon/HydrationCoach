//
//  CelebrationOverlayView.swift
//  HydrationCoach
//
//  Created by Sreejith Menon on 11/16/25.
//


// File: CelebrationOverlayView.swift

import SwiftUI

struct CelebrationOverlayView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                Text("Daily goal reached!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("Nice work staying hydrated today.")
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(32)
            .background(Color.black.opacity(0.7))
            .cornerRadius(24)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}
