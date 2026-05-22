//
//  StoryRepository.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Foundation

struct StoryRepository {
	func fetchStories() throws -> [StoryGroup] {
		guard let url = Bundle.main.url(forResource: "stories", withExtension: "json") else {
			throw StoryLoadingError.fileNotFound
		}
		
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode([StoryGroup].self, from: data)
	}
}

enum StoryLoadingError: Error {
	case fileNotFound
}
