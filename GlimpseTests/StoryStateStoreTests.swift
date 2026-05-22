//
//  StoryStateStoreTests.swift
//  GlimpseTests
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation
import Testing
@testable import Glimpse

@MainActor
struct StoryStateStoreTests {
	@Test
	func markSeenStoresItemAsSeen() {
		let store = makeStore()
		let item = StoryItem(id: "item_1", imageUrl: URL(string: "https://example.com/image.jpg")!)

		store.markSeen(item.id)

		#expect(store.isSeen(item))
	}

	@Test
	func toggleLikeAddsAndRemovesLike() {
		let store = makeStore()
		let item = StoryItem(id: "item_1", imageUrl: URL(string: "https://example.com/image.jpg")!)

		store.toggleLike(item.id)
		#expect(store.isLiked(item))

		store.toggleLike(item.id)
		#expect(!store.isLiked(item))
	}

	@Test
	func groupIsSeenOnlyWhenAllItemsAreSeen() {
		let store = makeStore()
		let group = makeGroup()

		store.markSeen(group.items[0].id)
		#expect(!store.isGroupSeen(group))

		store.markSeen(group.items[1].id)
		#expect(store.isGroupSeen(group))
	}

	@Test
	func firstUnseenItemIndexReturnsFirstUnseenItem() {
		let store = makeStore()
		let group = makeGroup()

		store.markSeen(group.items[0].id)

		#expect(store.firstUnseenItemIndex(in: group) == 1)
	}

	private func makeStore() -> StoryStateStore {
		let defaults = UserDefaults(suiteName: UUID().uuidString)!
		return StoryStateStore(userDefaults: defaults)
	}

	private func makeGroup() -> StoryGroup {
		StoryGroup(
			id: "group_1",
			username: "Alex",
			avatarUrl: URL(string: "https://example.com/avatar.jpg")!,
			items: [
				StoryItem(id: "item_1", imageUrl: URL(string: "https://example.com/1.jpg")!),
				StoryItem(id: "item_2", imageUrl: URL(string: "https://example.com/2.jpg")!)
			]
		)
	}
}
