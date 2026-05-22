//
//  StoryItem.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

struct StoryItem: Identifiable, Decodable, Hashable {
	let id: String
	let imageUrl: URL
	
	enum CodingKeys: String, CodingKey {
		case id
		case imageUrl = "imageURL"
	}
}

extension StoryItem {
	static let sample1 = StoryItem(id: "1", imageUrl: URL(string: "https://images.unsplash.com/photo-1550026593-cb89847b168d?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!)
	static let sample2 = StoryItem(id: "2", imageUrl: URL(string: "https://images.unsplash.com/photo-1508700929628-666bc8bd84ea?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!)
	static let sample3 = StoryItem(id: "3", imageUrl: URL(string: "https://images.unsplash.com/photo-1697661086713-1f196d82891e?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!)
}
