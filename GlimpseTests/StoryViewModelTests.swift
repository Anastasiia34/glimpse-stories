//
//  StoryViewModelTests.swift
//  Glimpse
//
//  Created by Hello Kitty on 22.05.2026.
//

import Foundation
import Testing
@testable import Glimpse

@MainActor
struct StoryViewModelTests {
	@Test
	func goNextMovesToNextItem() {
		let store = makeStore()
		let groups = [makeGroup()]

		let viewModel = StoryViewModel(
			storyGroups: groups,
			initialGroupIndex: 0,
			initialItemIndex: 0,
			stateStore: store
		)

		viewModel.goNext()

		#expect(viewModel.currentStoryItemIndex == 1)
	}

	@Test
	func goNextFromLastItemMovesToNextGroup() {
		let store = makeStore()

		let groups = [
			makeGroup(id: "group_1"),
			makeGroup(id: "group_2")
		]

		let viewModel = StoryViewModel(
			storyGroups: groups,
			initialGroupIndex: 0,
			initialItemIndex: 1,
			stateStore: store
		)

		viewModel.goNext()

		#expect(viewModel.currentStoryGroupIndex == 1)
		#expect(viewModel.currentStoryItemIndex == 0)
	}

	@Test
	func currentItemBecomesSeenAfterNavigation() {
		let store = makeStore()
		let groups = [makeGroup()]

		let viewModel = StoryViewModel(
			storyGroups: groups,
			initialGroupIndex: 0,
			initialItemIndex: 0,
			stateStore: store
		)

		viewModel.goNext()

		#expect(store.isSeen(viewModel.currentItem))
	}

	private func makeStore() -> StoryStateStore {
		let defaults = UserDefaults(suiteName: UUID().uuidString)!
		return StoryStateStore(userDefaults: defaults)
	}

	private func makeGroup(id: String = "group_1") -> StoryGroup {
		StoryGroup(
			id: id,
			username: "Alex",
			avatarUrl: URL(string: "https://example.com/avatar.jpg")!,
			items: [
				StoryItem(id: UUID().uuidString, imageUrl: URL(string: "https://example.com/1.jpg")!),
				StoryItem(id: UUID().uuidString, imageUrl: URL(string: "https://example.com/2.jpg")!)
			]
		)
	}
}
