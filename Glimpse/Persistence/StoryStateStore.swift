//
//  StoryStateStore.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

@MainActor
@Observable
final class StoryStateStore {
	private let seenKey = "seenStoryItemIds"
	private let likedKey = "likedStoryItemIds"
	
	private(set) var seenStoryItemIds: Set<String>
	private(set) var likedStoryItemIds: Set<String>
	
	private let userDefaults: UserDefaults
	
	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
		seenStoryItemIds = Set(userDefaults.stringArray(forKey: seenKey) ?? [])
		likedStoryItemIds = Set(userDefaults.stringArray(forKey: likedKey) ?? [])
	}
	
	// MARK: - Seen State
	func markSeen(_ itemId: String) {
		seenStoryItemIds.insert(itemId)
		saveSeen()
	}
	
	func isSeen(_ item: StoryItem) -> Bool {
		seenStoryItemIds.contains(item.id)
	}
	
	func isGroupSeen(_ group: StoryGroup) -> Bool {
		group.items.allSatisfy { seenStoryItemIds.contains($0.id) }
	}
	
	func firstUnseenItemIndex(in group: StoryGroup) -> Int {
		group.items.firstIndex { !seenStoryItemIds.contains($0.id) } ?? 0
	}
	
	private func saveSeen() {
		userDefaults.set(Array(seenStoryItemIds), forKey: seenKey)
	}
	
	// MARK: - Like State
	func toggleLike(_ itemId: String) {
		if likedStoryItemIds.contains(itemId) {
			likedStoryItemIds.remove(itemId)
		} else {
			likedStoryItemIds.insert(itemId)
		}
		
		saveLiked()
	}
	
	func isLiked(_ item: StoryItem) -> Bool {
		likedStoryItemIds.contains(item.id)
	}
	
	private func saveLiked() {
		userDefaults.set(Array(likedStoryItemIds), forKey: likedKey)
	}
}
