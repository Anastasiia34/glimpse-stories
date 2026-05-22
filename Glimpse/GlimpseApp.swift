//
//  GlimpseApp.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import SwiftUI

@main
struct GlimpseApp: App {
	@State private var stateStore = StoryStateStore()
	
    var body: some Scene {
        WindowGroup {
            StoryListView(stateStore: stateStore)
        }
    }
}
