//
//  ToastView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 19/08/26.
//

import SwiftUI

struct Toast: Equatable {
    var message: String
    var duration: TimeInterval = 1.0
}


struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        HStack{
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.white)
            Text(toast.message)
                .font(.footnote)
                .foregroundStyle(Color.white)
        }
        .padding(12)
        .background(Color(.green))
        .cornerRadius(16)
    }
}

struct ToastModifier : ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem : DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast {
                    ToastView(toast: toast)
                        .padding(.top, 65)
                        .transition(
                            .move(edge: .top)
                            .combined(with: .opacity)
                        )
                        .zIndex(1)
                }
            }
            .onChange(of: toast) {
                _, newValue in
                guard newValue != nil
                else { return }
                scheduleDismiss()
            }
            
    }
    
    private func scheduleDismiss() {
        workItem?.cancel()
        let task = DispatchWorkItem {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                toast = nil
            }
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + (toast?.duration ?? 1.0), execute: task)
    }

}

extension View {
    func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}

