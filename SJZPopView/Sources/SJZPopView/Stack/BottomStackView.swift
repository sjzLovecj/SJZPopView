//
//  PopupBottomStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct BottomStackView: View {
    let items: [AnyPop]
    @State private var heights: [AnyPop: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top, content: setupHudStack)
            .ignoresSafeArea()
            .animation(transitionAnimation, value: items)
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .background(setupTapArea())
            .gesture(hudDragGesture)
    }
}

private extension BottomStackView {
    func setupHudStack() -> some View {
        ForEach(items, id: \.self, content: setupHud)
    }
    
    func setupTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

private extension BottomStackView {
    func setupHud(_ item: AnyPop) -> some View {
        item.body
            .padding(.bottom, contentBottomPadding)
            .padding(.horizontal, contentHorizontalPadding)
            .overlay(
                GeometryReader { geo -> AnyView in
                    DispatchQueue.main.async{
                        heights[item] = geo.size.height
                    }
                    return AnyView(EmptyView())
                }
            )
            .background(backgroundColour)
            .cornerRadius(getCornerRadius(for: item))
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .top)
            .alignToBottom(bottomPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
            .shadow(color: config.shadowColour,
                    radius: config.shadowRadius,
                    x: config.shadowOffsetX,
                    y: config.shadowOffsetY)

    }
}

// MARK: -Gesture Handler
private extension BottomStackView {
    var hudDragGesture: some Gesture {
        DragGesture()
            .onChanged(onHudDragGestureChanged)
            .onEnded(onHudDragGestureEnded)
    }
    
    func onHudDragGestureChanged(_ value: DragGesture.Value) {
        gestureTranslation = max(0, value.translation.height)
    }
    
    func onHudDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor {
            items.last?.dismiss()
        }
        gestureTranslation = 0
    }
}

// MARK: -View Handlers
private extension BottomStackView {
    
    func getCornerRadius(for item: AnyPop) -> CGFloat {
        if isLast(item) {
            return cornerRadius.active
        }
        if gestureTranslation.isZero || !isNextToLast(item) {
            return cornerRadius.inactive
        }
        
        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    
    func getOpacity(for item: AnyPop) -> Double {
        if isLast(item) {
            return 1
        }
        if gestureTranslation.isZero {
            return  1 - invertedIndex(of: item).doubleValue * opacityFactor
        }
        
        let scaleValue = invertedIndex(of: item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    
    func getScale(for item: AnyPop) -> CGFloat {
        if isLast(item) {
            return 1
        }
        if gestureTranslation.isZero {
            return  1 - invertedIndex(of: item).floatValue * scaleFactor
        }
        
        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }

    func getOffset(for item: AnyPop) -> CGFloat {
        isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor
    }
}

private extension BottomStackView {
    func translationProgress() -> CGFloat {
        abs(gestureTranslation) / height
    }
    func isLast(_ item: AnyPop) -> Bool {
        items.last == item
    }
    func isNextToLast(_ item: AnyPop) -> Bool {
        index(of: item) == items.count - 2
    }
    func invertedIndex(of item: AnyPop) -> Int {
        items.count - 1 - index(of: item)
    }
    func index(of item: AnyPop) -> Int {
        items.firstIndex(of: item) ?? 0
    }
}

private extension BottomStackView {
    var height: CGFloat {
        if let hud = items.last, let hei = heights[hud]{
            return  hei
        }
        return  0
    }
    var contentBottomPadding: CGFloat {
        config.ignoresSafeArea ? 0 : max(UIScreen.safeArea.bottom - config.bottomPadding, 0)
    }
    var contentHorizontalPadding: CGFloat {
        config.horizontalPadding
    }
    var bottomPadding: CGFloat {
        config.bottomPadding
    }
    var maxHeightFactor: CGFloat {
        12
    }
    var maxHeightStackedFactor: CGFloat {
        0.85
    }
    var opacityFactor: Double {
        1 / config.maxStackCount.doubleValue
    }
    var offsetFactor: CGFloat {
        -config.stackViewsOffset
    }
    var scaleFactor: CGFloat {
        config.stackViewsScale
    }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) {
        (config.cornerRadius, config.stackViewsCornerRadius)
    }
    var backgroundColour: Color {
        config.backgroundColour
    }
    var transitionAnimation: Animation {
        config.transitionAnimation
    }
    var dragGestureAnimation: Animation {
        config.dragGestureAnimation
    }
    var gestureClosingThresholdFactor: CGFloat {
        config.dragGestureProgressToClose
    }
    var transition: AnyTransition {
        .move(edge: .bottom)
    }
    var config: PopConfig {
        items.last?.setupConfig(PopConfig()) ?? .init()
    }
}
