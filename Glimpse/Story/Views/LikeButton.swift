//
//  LikeButton.swift
//  Glimpse
//
//  Created by Hello Kitty on 22.05.2026.
//

import SwiftUI

struct LikeButton: View {
	let isLiked: Bool
	let toggleLike: () -> Void
	
	@State var scale = 1.0
	
	var body: some View {
		Button {
			toggleWithAnimation()
		} label: {
			Image(systemName: isLiked ? "heart.fill" : "heart")
				.font(.title)
				.foregroundStyle(isLiked ? .red : .white)
				.scaleEffect(scale)
		}
	}
	
	func toggleWithAnimation() {
		withAnimation(.linear(duration: 0.1)) {
			scale = 1.2
		}
		withAnimation(.linear(duration: 0.1).delay(0.1)) {
			scale = 1.0
		}
		toggleLike()
	}
}

#Preview {
	LikeButton(isLiked: false, toggleLike: {})
}
