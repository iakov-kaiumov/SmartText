import SwiftUI

final class TextViewStore: ObservableObject {
    @Published var intrinsicContentSize: CGSize?

    func didUpdateTextView(_ textView: TextViewWrapper.View) {
        intrinsicContentSize = textView.intrinsicContentSize
    }
}
