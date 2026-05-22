//
//  StoryListViewModel.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

@MainActor
@Observable
final class StoryListViewModel {
	var selectedStoryViewContext: StoryView.Context?
	let stateStore: StoryStateStore
	
	private(set) var storyGroups = [StoryGroup]()
	private(set) var visibleStoryGroupIndexes = [Int]()
	private(set) var state = State.idle
	
	private let repository = StoryRepository()
	private let pageSize = 10
	
	enum State {
		case idle, loaded, failed
	}
	
	init(stateStore: StoryStateStore) {
		self.stateStore = stateStore
	}
	
	func loadStories() {
		do {
			storyGroups = try repository.fetchStories()
			state = storyGroups.isEmpty ? .failed : .loaded
			loadNextPageIfNeeded(currentIndex: nil)
		} catch {
			state = .failed
		}
	}
	
	func loadNextPageIfNeeded(currentIndex: Int?) {
		guard !storyGroups.isEmpty, shouldLoadNextPage(for: currentIndex) else {
			return
		}
		
		let startIndex = visibleStoryGroupIndexes.count
		let nextIndexes = (startIndex..<(startIndex + pageSize))
		visibleStoryGroupIndexes.append(contentsOf: nextIndexes)
	}
	
	private func shouldLoadNextPage(for currentIndex: Int?) -> Bool {
		guard let currentIndex else {
			return true
		}

		let thresholdIndex = visibleStoryGroupIndexes.endIndex - 3
		return currentIndex >= thresholdIndex
	}
	
	func storyGroup(at visibleIndex: Int) -> StoryGroup? {
		guard !storyGroups.isEmpty else {
			return nil
		}
		
		let storyIndex = visibleStoryGroupIndexes[visibleIndex]
		return storyGroups[storyIndex % storyGroups.count]
	}
	
	func isStoryGroupSeen(_ group: StoryGroup) -> Bool {
		stateStore.isGroupSeen(group)
	}
	
	func selectStoryGroup(at visibleIndex: Int) {
		guard let group = storyGroup(at: visibleIndex) else {
			return
		}
		
		let itemIndex = stateStore.firstUnseenItemIndex(in: group)
		selectedStoryViewContext = StoryView.Context(initialGroupIndex: visibleIndex, initialItemIndex: itemIndex)
	}
}
