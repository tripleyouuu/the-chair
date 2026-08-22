//
//  CustomBackButton.swift
//
//  Replaces the system back button with a custom asset image
//  (no Liquid Glass, since it's not a system-style bar item).
//  Manually re-enables swipe-to-go-back since a custom
//  leftBarButtonItem disables it by default.
//
//  Tradeoff vs. the native back button: no long-press
//  navigation-stack menu. That's a system feature tied
//  specifically to the real backBarButtonItem.
//

import SwiftUI
import UIKit

struct CustomBackButtonModifier: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            guard let navigationController = uiViewController.navigationController,
                  navigationController.viewControllers.count > 1,
                  let topItem = navigationController.viewControllers.last?.navigationItem else { return }

            // Only set it once per screen
            if topItem.leftBarButtonItem?.tag != 9999 {
                let backImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)

                // Tune these two to match the size/position of your other
                // nav bar buttons (e.g. the trailing gear button).
                let buttonSize: CGFloat = 44
                let leadingInset: CGFloat = 0

                let button = UIButton(type: .custom)
                button.setImage(backImage, for: .normal)
                button.imageView?.contentMode = .scaleAspectFit
                button.addTarget(context.coordinator, action: #selector(Coordinator.goBack), for: .touchUpInside)
                button.frame = CGRect(x: leadingInset, y: 0, width: buttonSize, height: buttonSize)

                // A container gives the button standard leading padding and
                // lets the nav bar vertically center it like a system item.
                let container = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize + leadingInset, height: buttonSize))
                container.addSubview(button)

                let barItem = UIBarButtonItem(customView: container)
                barItem.tag = 9999
                if #available(iOS 26.0, *) {
                    barItem.hidesSharedBackground = true
                }

                topItem.leftBarButtonItem = barItem
                topItem.hidesBackButton = true
            }

            // Custom leftBarButtonItem disables the interactive swipe gesture
            // by default — manually re-enable it.
            context.coordinator.navigationController = navigationController
            navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
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
    func customBackButton() -> some View {
        self.background(CustomBackButtonModifier().frame(width: 0, height: 0))
    }
}
