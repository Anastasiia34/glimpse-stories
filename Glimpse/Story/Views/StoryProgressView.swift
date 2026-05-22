//
//  StoryProgressView.swift
//  Glimpse
//
//  Created by Hello Kitty on 22.05.2026.
//

import SwiftUI

struct StoryProgressView: View {
	let progress: Double
	
	private var safeProgress: Double {
		guard progress.isFinite else {
			return 0
		}
		
		return min(max(progress, 0), 1)
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Capsule()
					.fill(.white.opacity(0.3))
				
				Capsule()
					.fill(.white)
					.frame(width: geometry.size.width * safeProgress)
			}
		}
		.frame(height: 3)
	}
}

#Preview {
	StoryProgressView(progress: 0.4)
}
