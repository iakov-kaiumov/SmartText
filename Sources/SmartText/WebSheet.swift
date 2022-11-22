
import SwiftUI
import WebKit
import SafariServices

class ObservableURL: ObservableObject {
    @Published var url: URL?
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        return SFSafariViewController(url: url, configuration: configuration)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}


struct WebSheet: View {
    
    var url: URL
    
    var body: some View {
        SafariView(url: url)
            .edgesIgnoringSafeArea(.bottom)
    }
}
