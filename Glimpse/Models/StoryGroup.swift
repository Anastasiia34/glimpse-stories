//
//  StoryGroup.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

struct StoryGroup: Identifiable, Decodable, Hashable {
	let id: String
	let username: String
	let avatarUrl: URL
	let items: [StoryItem]
	
	enum CodingKeys: String, CodingKey {
		case id, username, items
		case avatarUrl = "avatarURL"
	}
}

extension StoryGroup {
	static let sample = StoryGroup(id: "1", username: "Mason", avatarUrl: URL(string: "https://images.unsplash.com/photo-1546427660-eb346c344ba5?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!, items: [.sample1, .sample2, .sample3])
}
