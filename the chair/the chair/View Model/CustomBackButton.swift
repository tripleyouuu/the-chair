//
//  CustomBackButton.swift
//
//  Single back-button controller for a screen: either shows a custom
//  asset (with swipe-to-go-back re-enabled) or hides the back button
//  entirely. One representable type driven by a mode (not two types
//  swapped via if/else, which caused a teardown/remount race).
//
//  Reapplies on every `viewWillLayoutSubviews`, not just on SwiftUI
//  render passes. iOS 26 can silently reset a nav item's
//  leftBarButtonItem when heavy content changes happen elsewhere on
//  screen (e.g. a ScrollView/List being swapped for plain Text, like
//  an empty search-results state). That reset can happen in its own
//  layout pass slightly after ours — if nothing further triggers a
//  SwiftUI re-render, nothing would correct it. Hooking layout passes
//  directly makes it self-heal regardless of what triggered the reset.
//

import SwiftUI
import UIKit

enum BackButtonMode {
    case custom
    case hidden
}

final class BackButtonHostingController: UIViewController {
    var mode: BackButtonMode = .hidden
    weak var coordinator: BackButtonModifier.Coordinator?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        applyBackButtonState()
    }

    func applyBackButtonState() {
        guard let navigationController = navigationController,
              navigationController.viewControllers.count > 1,
              let topItem = navigationController.viewControllers.last?.navigationItem,
              let coordinator = coordinator else { return }

        switch mode {
        case .hidden:
            topItem.leftBarButtonItem = nil
            topItem.hidesBackButton = true

        case .custom:
            let backImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)

            let buttonSize: CGFloat = 44
            let leadingInset: CGFloat = 0

            let button = UIButton(type: .custom)
            button.setImage(backImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(coordinator, action: #selector(BackButtonModifier.Coordinator.goBack), for: .touchUpInside)
            button.frame = CGRect(x: leadingInset, y: 0, width: buttonSize, height: buttonSize)

            let container = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize + leadingInset, height: buttonSize))
            container.addSubview(button)

            let barItem = UIBarButtonItem(customView: container)
            barItem.tag = 9999
            if #available(iOS 26.0, *) {
                barItem.hidesSharedBackground = true
            }

            topItem.leftBarButtonItem = barItem
            topItem.hidesBackButton = true

            coordinator.navigationController = navigationController
            navigationController.interactivePopGestureRecognizer?.delegate = coordinator
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

struct BackButtonModifier: UIViewControllerRepresentable {
    let mode: BackButtonMode

    func makeUIViewController(context: Context) -> BackButtonHostingController {
        let vc = BackButtonHostingController()
        vc.coordinator = context.coordinator
        vc.mode = mode
        return vc
    }

    func updateUIViewController(_ uiViewController: BackButtonHostingController, context: Context) {
        uiViewController.mode = mode
        // Apply right away for the common case (fast feedback on state
        // changes like the list/grid toggle); viewWillLayoutSubviews
        // covers everything else, including resets we didn't cause.
        DispatchQueue.main.async {
            uiViewController.applyBackButtonState()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var navigationController: UINavigationController?

        @objc func goBack() {
            navigationController?.popViewController(animated: true)
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            (navigationController?.viewControllers.count ?? 0) > 1
        }
    }
}

extension View {
    /// Set the back button for this screen. Pass `.custom` for your
    /// asset button (with swipe-to-go-back), or `.hidden` for no
    /// back button at all.
    func backButton(_ mode: BackButtonMode) -> some View {
        self.background(BackButtonModifier(mode: mode).frame(width: 0, height: 0))
    }
}
