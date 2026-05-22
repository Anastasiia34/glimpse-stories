//
//  StoryViewModel.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

@MainActor
@Observable
final class StoryViewModel {
	let storyGroups: [StoryGroup]
	
	private let stateStore: StoryStateStore
	private let storyItemDuration: TimeInterval = 5
	
	private(set) var currentStoryGroupIndex: Int
	private(set) var currentStoryItemIndex: Int
	private(set) var isOverlayHidden = false
	
	private var isPaused = false
	private var accumulatedProgressTime: TimeInterval = 0
	private var activeProgressStartDate = Date()
	private var autoAdvanceTask: Task<Void, Never>?
	private var lastItemIndexByGroupId = [String: Int]()
	
	var currentGroup: StoryGroup {
		storyGroups[currentStoryGroupIndex % storyGroups.count]
	}
	
	var currentItem: StoryItem {
		currentGroup.items[currentStoryItemIndex]
	}
	
	var currentItemLiked: Bool {
		stateStore.isLiked(currentItem)
	}
	
	init(storyGroups: [StoryGroup], initialGroupIndex: Int, initialItemIndex: Int, stateStore: StoryStateStore) {
		self.storyGroups = storyGroups
		currentStoryGroupIndex = initialGroupIndex
		currentStoryItemIndex = initialItemIndex
		self.stateStore = stateStore
		markCurrentItemSeen()
	}
	
	// MARK: - Navigation
	func goNext() {
		if currentStoryItemIndex < currentGroup.items.count - 1 {
			currentStoryItemIndex += 1
			completeNavigation()
		} else {
			goNextGroup()
		}
	}
	
	func goPrevious() {
		if currentStoryItemIndex > 0 {
			currentStoryItemIndex -= 1
			completeNavigation()
		} else {
			goPreviousGroup()
		}
	}
	
	func goNextGroup() {
		rememberCurrentItemIndex()
		currentStoryGroupIndex += 1
		restoreItemIndexForCurrentGroup()
		completeNavigation()
	}
	
	func goPreviousGroup() {
		rememberCurrentItemIndex()
		currentStoryGroupIndex = max(0, currentStoryGroupIndex - 1)
		restoreItemIndexForCurrentGroup()
		completeNavigation()
	}
	
	private func completeNavigation() {
		restartProgress()
		markCurrentItemSeen()
	}
	
	// MARK: - Progress
	func startAutoAdvance() {
		stopAutoAdvance()
		
		autoAdvanceTask = Task { [weak self] in
			guard let self else {
				return
			}
			
			while !Task.isCancelled {
				try? await Task.sleep(for: .milliseconds(100))
				if !isPaused, progress(for: currentStoryItemIndex, at: Date()) >= 1 {
					goNext()
				}
			}
		}
	}
	
	func stopAutoAdvance() {
		autoAdvanceTask?.cancel()
		autoAdvanceTask = nil
	}
	
	func progress(for itemIndex: Int, at date: Date) -> Double {
		if itemIndex < currentStoryItemIndex {
			return 1
		}
		
		if itemIndex > currentStoryItemIndex {
			return 0
		}
		
		guard storyItemDuration > 0 else {
			return 1
		}

		let elapsed = currentItemElapsedTime(at: date)
		let progress = elapsed / storyItemDuration

		guard progress.isFinite else {
			return 0
		}

		return min(max(progress, 0), 1)
	}
	
	func pauseProgress() {
		guard !isPaused else {
			return
		}
		
		accumulatedProgressTime += Date().timeIntervalSince(activeProgressStartDate)
		isPaused = true
	}
	
	func resumeProgress() {
		guard isPaused else {
			return
		}
		
		activeProgressStartDate = Date()
		isPaused = false
	}
	
	func restartProgress() {
		accumulatedProgressTime = 0
		activeProgressStartDate = Date()
		isPaused = false
	}
	
	private func currentItemElapsedTime(at date: Date) -> Double {
		if isPaused {
			return accumulatedProgressTime
		}
		
		return accumulatedProgressTime + date.timeIntervalSince(activeProgressStartDate)
	}
	
	// MARK: Interaction State
	func toggleLikeForCurrentItem() {
		stateStore.toggleLike(currentItem.id)
	}
	
	func hideOverlay() {
		isOverlayHidden = true
	}

	func showOverlay() {
		isOverlayHidden = false
	}
	
	// MARK: Private Helpers
	private func rememberCurrentItemIndex() {
		lastItemIndexByGroupId[currentGroup.id] = currentStoryItemIndex
	}
	
	private func restoreItemIndexForCurrentGroup() {
		currentStoryItemIndex = lastItemIndexByGroupId[currentGroup.id] ?? 0
	}
	
	private func markCurrentItemSeen() {
		stateStore.markSeen(currentItem.id)
	}
}
