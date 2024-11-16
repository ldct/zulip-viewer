import SwiftUI

struct StreamSummaryView: View {
    let stream: Stream
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
                .font(.headline)
            if !stream.description.isEmpty {
                if let renderedDescription = try? AttributedString(markdown: stream.description) {
                    Text(renderedDescription)
                        .font(.subheadline)
                } else {
                    Text(stream.description)
                        .font(.subheadline)
                }
            }
        }
    }
}
