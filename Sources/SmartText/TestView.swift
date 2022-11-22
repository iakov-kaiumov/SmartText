//
//  SwiftUIView.swift
//  
//
//  Created by Яков Каюмов on 22.02.2022.
//

import SwiftUI
import LoremSwiftum

struct SwiftUIView: View {
    @State var sliderValue: CGFloat = 1.0
    
    @State var attributedString: NSAttributedString = NSAttributedString(string: "")
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack(spacing: 16) {
                    Slider(value: $sliderValue, in: 0.5...1)
                        .padding(.horizontal)
                    
                    
                    SmartText(attributedString)
                        .padding()
                        .frame(width: sliderValue * reader.size.width)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            update()
        }
    }
    
    func update() {
        DispatchQueue.main.async {
            attributedString = NSAttributedString(
                string: Lorem.paragraphs(2),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.systemGray
                ]
            )
        }
    }
}


@available(iOS 15.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .previewInterfaceOrientation(.portrait)
    }
}
