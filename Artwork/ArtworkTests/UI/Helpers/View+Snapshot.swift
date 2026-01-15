//
//  View+Snapshot.swift
//  Artwork
//
//  Created by Rafael Rios on 09/01/26.
//

import AppKit
import SwiftUI

extension View {
    func snapshot(for configuration: SnapshotConfiguration) -> NSImage {
        let backgroundColor: Color =
        configuration.colorScheme == .dark ? .black : .white
        
        let hostingView = NSHostingView(
            rootView:
                self
                .background(backgroundColor)
                .environment(\.colorScheme, configuration.colorScheme)
        )
        
        hostingView.frame = NSRect(origin: .zero, size: configuration.size)
        hostingView.appearance = configuration.appearance
        
        let window = SnapshotWindow(
            configuration: configuration,
            rootView: hostingView
        )
        
        return window.snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let appearance: NSAppearance
    let colorScheme: ColorScheme

    static func light() -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            appearance: NSAppearance(named: .aqua)!,
            colorScheme: .light
        )
    }

    static func dark() -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            appearance: NSAppearance(named: .darkAqua)!,
            colorScheme: .dark
        )
    }
}

private final class SnapshotWindow: NSWindow {

    private let configuration: SnapshotConfiguration

    init(configuration: SnapshotConfiguration, rootView: NSView) {
        self.configuration = configuration

        let rect = NSRect(origin: .zero, size: configuration.size)

        super.init(
            contentRect: rect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        isOpaque = true
        hasShadow = false
        backgroundColor = .clear
        appearance = configuration.appearance

        let containerView = NSView(frame: rect)
        containerView.appearance = configuration.appearance
        self.contentView = containerView

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.appearance = configuration.appearance

        containerView.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        makeKeyAndOrderFront(nil)
        displayIfNeeded()
    }

    func snapshot() -> NSImage {
        guard let contentView else {
            return NSImage(size: configuration.size)
        }

        let rep = contentView.bitmapImageRepForCachingDisplay(in: contentView.bounds)!
        contentView.cacheDisplay(in: contentView.bounds, to: rep)

        let image = NSImage(size: contentView.bounds.size)
        image.addRepresentation(rep)
        return image
    }
}
