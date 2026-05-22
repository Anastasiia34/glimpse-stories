//
//  StoryProgressBarsView.swift
//  Glimpse
//
//  Created by Hello Kitty on 22.05.2026.
//

import SwiftUI

struct StoryProgressBarsView: View {
	let itemCount: Int
	let progress: (Int, Date) -> Double
	
	var body: some View {
		TimelineView(.animation) { context in
			HStack(spacing: 2) {
				ForEach(0..<itemCount, id: \.self) { index in
					StoryProgressView(
						progress: progress(index, context.date)
					)
				}
			}
		}
		.padding(.top, 5)
		.transaction { transaction in
			transaction.animation = nil
		}
	}
}

#Preview {
	StoryProgressBarsView(itemCount: 3) { _, _ in 0.5 }
}
