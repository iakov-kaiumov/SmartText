
import SwiftUI

public struct SmartText: View {
    @StateObject private var textViewStore = TextViewStore()
    
    @State private var showWebSheet: Bool = false
    
    @ObservedObject private var webURL: ObservableURL = ObservableURL(nil)

    private let attributedText: NSAttributedString

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
                showWebSheet: $showWebSheet
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

private extension GeometryProxy {
    var maxWidth: CGFloat {
        size.width - safeAreaInsets.leading - safeAreaInsets.trailing
    }
}
