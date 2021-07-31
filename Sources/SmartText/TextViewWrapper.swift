import UIKit
import SwiftUI


final class TextViewStore: ObservableObject {
    @Published var intrinsicContentSize: CGSize?

    func didUpdateTextView(_ textView: TextViewWrapper.View) {
        intrinsicContentSize = textView.intrinsicContentSize
    }
}


struct TextViewWrapper: UIViewRepresentable {
    
    final class View: UITextView {
        var maxLayoutWidth: CGFloat = 0 {
            didSet {
                guard maxLayoutWidth != oldValue else { return }
                invalidateIntrinsicContentSize()
            }
        }

        override var intrinsicContentSize: CGSize {
            if super.intrinsicContentSize.width < maxLayoutWidth {
                return super.intrinsicContentSize
            }
            
            guard maxLayoutWidth > 0 else {
                return super.intrinsicContentSize
            }
            
            return sizeThatFits(
                CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude)
            )
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(_ view: TextViewWrapper) {
            self.parent = view
        }

        func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange, interaction: UITextItemInteraction) -> Bool {
            
            if interaction == .invokeDefaultAction {
                openURL(URL)
                return false
            }
            
            return true
        }
        
        func openURL(_ url: URL) {
            if parent.useInbuiltBrowser {
                if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                    // Can open with SFSafariViewController
                    DispatchQueue.main.async {
                        self.parent.webURL.url = url
                        self.parent.showWebSheet = true
                    }
                    return
                }
            }
            // Scheme is not supported or no scheme is given, use openURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    let attributedText: NSAttributedString
    let maxLayoutWidth: CGFloat
    let textViewStore: TextViewStore
    @ObservedObject var webURL: ObservableURL
    @Binding var showWebSheet: Bool
    let dataDetectorTypes: UIDataDetectorTypes
    let useInbuiltBrowser: Bool = true

    func makeUIView(context: Context) -> View {
        let uiView = View()
        uiView.backgroundColor = .clear
        uiView.textContainerInset = .zero
        uiView.isEditable = false
        uiView.isScrollEnabled = false
        uiView.textContainer.lineFragmentPadding = 0
        uiView.dataDetectorTypes = dataDetectorTypes
        uiView.delegate = context.coordinator
        return uiView
    }

    func updateUIView(_ uiView: View, context: Context) {
        uiView.attributedText = attributedText
        uiView.maxLayoutWidth = maxLayoutWidth

        uiView.textContainer.maximumNumberOfLines = context.environment.lineLimit ?? 0
        uiView.textContainer.lineBreakMode = NSLineBreakMode(truncationMode: context.environment.truncationMode)

        textViewStore.didUpdateTextView(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
