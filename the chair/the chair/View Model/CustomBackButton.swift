//
//  CustomBackButton.swift
//
//  Single back-button controller for a screen: either shows a custom
//  asset (with swipe-to-go-back re-enabled) or hides the back button
//  entirely. Deliberately ONE representable type driven by a mode,
//  rather than two different types swapped via if/else — swapping
//  types forces SwiftUI to tear down/remount the invisible child
//  controller on every toggle, which raced two async closures against
//  each other and could leave a dead, orphaned button on screen.
//

import SwiftUI
import UIKit

enum BackButtonMode {
    case custom
    case hidden
}

struct BackButtonModifier: UIViewControllerRepresentable {
    let mode: BackButtonMode

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let mode = self.mode // snapshot the value this update was called with
        DispatchQueue.main.async {
            guard let navigationController = uiViewController.navigationController,
                  navigationController.viewControllers.count > 1,
                  let topItem = navigationController.viewControllers.last?.navigationItem else { return }

            switch mode {
            case .hidden:
                topItem.leftBarButtonItem = nil
                topItem.hidesBackButton = true

            case .custom:
                // Reapply every update pass rather than skipping once already
                // set — heavy structural changes elsewhere on screen (e.g. a
                // List being swapped for other content) can cause the system
                // to silently reset the nav item's leftBarButtonItem. Keeping
                // this unconditional makes it self-heal instead of leaving a
                // stale native button behind.
                let backImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)

                let buttonSize: CGFloat = 44
                let leadingInset: CGFloat = 0

                let button = UIButton(type: .custom)
                button.setImage(backImage, for: .normal)
                button.imageView?.contentMode = .scaleAspectFit
                button.addTarget(context.coordinator, action: #selector(Coordinator.goBack), for: .touchUpInside)
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

                context.coordinator.navigationController = navigationController
                navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
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
