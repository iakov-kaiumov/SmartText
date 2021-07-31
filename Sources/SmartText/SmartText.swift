import UIKit
import SwiftUI


/**
 UITextView analog for SwiftUI
 */
public struct SmartText: View {
    @StateObject private var textViewStore = TextViewStore()
    
    @State private var showWebSheet: Bool = false
    
    @State private var webURL: ObservableURL = ObservableURL()

    private let attributedText: NSAttributedString
    
    private var dataDetectorTypes: UIDataDetectorTypes = .link
    
    private var useInbuiltBrowser: Bool = true

    public init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    public var body: some View {
        GeometryReader { geometry in
            TextViewWrapper(
                attributedText: attributedText,
                maxLayoutWidth: geometry.maxWidth,
                textViewStore: textViewStore,
                webURL: webURL,
                showWebSheet: $showWebSheet,
                dataDetectorTypes: dataDetectorTypes
            )
        }
        .frame(
            idealWidth: textViewStore.intrinsicContentSize?.width,
            idealHeight: textViewStore.intrinsicContentSize?.height
        )
        .fixedSize(horizontal: false, vertical: true)
        .sheet(isPresented: $showWebSheet) {
            WebSheet(url: webURL.url!)
        }
    }
}

public extension SmartText {
    func dataDetectorTypes(_ dataDetectorTypes: UIDataDetectorTypes) -> SmartText {
        var view = self
        view.dataDetectorTypes = dataDetectorTypes
        return view
    }
    
    func useInbuiltBrowser(_ use: Bool) -> SmartText {
        var view = self
        view.useInbuiltBrowser = use
        return view
    }
}

private extension GeometryProxy {
    var maxWidth: CGFloat {
        size.width - safeAreaInsets.leading - safeAreaInsets.trailing
    }
}
