//
//  SquareGuideOverlayView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 21/08/26.
//

import SwiftUI

class SquareGuideOverlayView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }


        let squareSize = rect.width
        let squareRect = CGRect(
            x: 0,
            y: (rect.height - squareSize) / 2,
            width: squareSize,
            height: squareSize
        )

        context.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        context.fill(rect)

        context.setBlendMode(.clear)
        context.fill(squareRect)
        context.setBlendMode(.normal)
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2)
        context.stroke(squareRect)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
        isUserInteractionEnabled = false
    }
}
