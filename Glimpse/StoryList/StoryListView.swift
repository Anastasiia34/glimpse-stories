//
//  StoryListView.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import SwiftUI

struct StoryListView: View {
	@State private var viewModel: StoryListViewModel
	
	init(stateStore: StoryStateStore) {
		_viewModel = State(initialValue: StoryListViewModel(stateStore: stateStore))
	}
	
	var body: some View {
		VStack {
			switch viewModel.state {
			case .loaded:
				ScrollView(.horizontal, showsIndicators: false) {
					LazyHStack(spacing: 16) {
						ForEach(viewModel.visibleStoryGroupIndexes.indices, id: \.self) { visibleIndex in
							if let group = viewModel.storyGroup(at: visibleIndex) {
								StoryCircleView(avatarUrl: group.avatarUrl, isSeen: viewModel.isStoryGroupSeen(group))
									.onTapGesture {
										viewModel.selectStoryGroup(at: visibleIndex)
									}
									.onAppear {
										viewModel.loadNextPageIfNeeded(currentIndex: visibleIndex)
									}
							}
						}
					}
					.padding(.horizontal, 16)
				}
			case .idle:
				ProgressView()
			case .failed:
				ContentUnavailableView("Unable to load stories", systemImage: "exclamationmark.triangle", description: Text("Please try again later."))
			}
		}
		.onAppear {
			if viewModel.storyGroups.isEmpty {
				viewModel.loadStories()
			}
		}
		.fullScreenCover(item: $viewModel.selectedStoryViewContext) { context in
			StoryView(
				storyGroups: viewModel.storyGroups,
				initialGroupIndex: context.initialGroupIndex,
				initialItemIndex: context.initialItemIndex,
				stateStore: viewModel.stateStore
			)
		}
	}
}

#Preview {
	StoryListView(stateStore: StoryStateStore())
}
