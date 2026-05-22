//
//  StoryView.swift
//  Glimpse
//
//  Created by Hello Kitty on 21.05.2026.
//

import Kingfisher
import SwiftUI

struct StoryView: View {
	@State private var viewModel: StoryViewModel
	@Environment(\.dismiss) private var dismiss
	
	@State private var dragOffsetY: CGFloat = 0
	@State private var pressTask: Task<Void, Never>?
	@State private var isDragging = false
	
	private let maxDragOffsetY: CGFloat = 100
	private let dismissThreshold: CGFloat = 140
	private let groupSwipeThreshold: CGFloat = 60
	private let dragResistance: CGFloat = 0.35
	
	private let dragResetAnimation = Animation.spring(response: 0.35, dampingFraction: 0.85)
	
	init(storyGroups: [StoryGroup], initialGroupIndex: Int, initialItemIndex: Int, stateStore: StoryStateStore) {
		_viewModel = State(initialValue: StoryViewModel(storyGroups: storyGroups, initialGroupIndex: initialGroupIndex, initialItemIndex: initialItemIndex, stateStore: stateStore))
	}
	
	var body: some View {
		ZStack {
			VStack {
				ZStack {
					GeometryReader { proxy in
						ZStack {
							KFImage(viewModel.currentItem.imageUrl)
								.resizable()
								.scaledToFill()
								.frame(width: proxy.size.width, height: proxy.size.height)
								.clipShape(RoundedRectangle(cornerRadius: 5))
							HStack {
								tapZone {
									viewModel.goPrevious()
								}
								
								Spacer()
								
								tapZone {
									viewModel.goNext()
								}
							}
						}
					}
					
					VStack {
						StoryProgressBarsView(itemCount: viewModel.currentGroup.items.count, progress: viewModel.progress)
						
						HStack {
							Spacer()
							
							Button {
								dismiss()
							} label: {
								Image(systemName: "xmark")
									.font(.title)
									.foregroundStyle(.white)
							}
							
						}
						.padding(.top, 5)
						
						Spacer()
					}
					.padding(.horizontal, 5)
					.opacity(viewModel.isOverlayHidden ? 0 : 1)
				}
				
				HStack {
					Spacer()
					
					LikeButton(isLiked: viewModel.currentItemLiked) { viewModel.toggleLikeForCurrentItem()
					}
					.padding()
					.opacity(viewModel.isOverlayHidden ? 0 : 1)
				}
			}
			.offset(y: dragOffsetY)
		}
		.background(.black)
		.animation(.easeInOut(duration: 0.15), value: viewModel.isOverlayHidden)
		.onAppear {
			viewModel.startAutoAdvance()
		}
		.onDisappear {
			pressTask?.cancel()
			viewModel.stopAutoAdvance()
		}
		.gesture(storyGesture)
	}
	
	private func tapZone(action: @escaping () -> Void) -> some View {
		Color.clear
			.contentShape(Rectangle())
			.frame(width: 100)
			.frame(maxHeight: .infinity)
			.onTapGesture(perform: action)
	}
	
	private var storyGesture: some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged(handleDragChanged)
			.onEnded(handleDragEnded)
	}
	
	private func handleDragChanged(_ value: DragGesture.Value) {
		if !isDragging {
			isDragging = true
			viewModel.pauseProgress()
			scheduleOverlayHiding()
		}
		
		let translation = value.translation
		
		if translation.height > 0,
		   abs(translation.height) > abs(translation.width) {
			dragOffsetY = min(translation.height * dragResistance, maxDragOffsetY)
		}
	}
	
	private func handleDragEnded(_ value: DragGesture.Value) {
		pressTask?.cancel()
		isDragging = false
		
		let translation = value.translation
		
		defer {
			viewModel.showOverlay()
			viewModel.resumeProgress()
		}
		
		if shouldDismiss(translation) {
			dismiss()
			return
		}
		
		if dragOffsetY > 0 {
			resetVerticalDragOffset()
			return
		}
		
		if shouldGoNextGroup(translation) {
			withAnimation(dragResetAnimation) {
				viewModel.goNextGroup()
			}
			return
		}
		
		if shouldGoPreviousGroup(translation) {
			withAnimation(dragResetAnimation) {
				viewModel.goPreviousGroup()
			}
			return
		}
	}
	
	private func scheduleOverlayHiding() {
		pressTask?.cancel()
		
		pressTask = Task {
			try? await Task.sleep(for: .seconds(1))
			guard !Task.isCancelled else { return }
			
			await MainActor.run {
				viewModel.hideOverlay()
			}
		}
	}
	
	private func shouldDismiss(_ translation: CGSize) -> Bool {
		translation.height > dismissThreshold && abs(translation.height) > abs(translation.width)
	}
	
	private func shouldGoNextGroup(_ translation: CGSize) -> Bool {
		translation.width < -groupSwipeThreshold && abs(translation.width) > abs(translation.height)
	}
	
	private func shouldGoPreviousGroup(_ translation: CGSize) -> Bool {
		translation.width > groupSwipeThreshold && abs(translation.width) > abs(translation.height)
	}
	
	private func resetVerticalDragOffset() {
		withAnimation(dragResetAnimation) {
			dragOffsetY = 0
		}
	}
}

extension StoryView {
	struct Context: Identifiable {
		let id = UUID()
		let initialGroupIndex: Int
		let initialItemIndex: Int
	}
}

#Preview {
	StoryView(storyGroups: [.sample], initialGroupIndex: 0, initialItemIndex: 0, stateStore: StoryStateStore())
}
