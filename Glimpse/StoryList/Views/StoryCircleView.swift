//
//  StoryCircleView.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Kingfisher
import SwiftUI

struct StoryCircleView: View {
	let avatarUrl: URL
	let isSeen: Bool
	
	var body: some View {
		ZStack {
			Circle()
				.strokeBorder(
					isSeen
					? AnyShapeStyle(Color.gray.opacity(0.5))
					: AnyShapeStyle(
						LinearGradient(
							colors: [.blue, .purple],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					),
					lineWidth: 5
				)
				.frame(width: 85, height: 85)
			
			KFImage(avatarUrl)
				.resizable()
				.scaledToFill()
				.frame(width: 70, height: 70)
				.clipShape(.circle)
		}
	}
}

#Preview {
	StoryCircleView(avatarUrl: StoryGroup.sample.avatarUrl, isSeen: false)
}
