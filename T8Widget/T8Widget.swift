import WidgetKit
import SwiftUI
import SwiftSoup

private func formattedLastUpdateTime(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    return dateFormatter.string(from: date)
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Загрузка...")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "Загрузка...")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        if let url = URL(string: "https://ru.busti.me/saransk/trolleybus-8/") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let html = String(data: data, encoding: .utf8),
                   let doc = try? SwiftSoup.parse(html),
                   let tdElements = try? doc.select("td:has(img)"),
                   !tdElements.isEmpty {
                    
                    var entryText = ""
                    for (i, tdElement) in zip(tdElements.indices, tdElements) {
                        if let tdText = try? tdElement.text() {
                            entryText += "\(i+1). \(tdText)\n"
                        }
                    }
                    let entry = SimpleEntry(date: Date(), text: entryText)
                    entries.append(entry)
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            }.resume()
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct T8WidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            VStack(alignment: .leading){
                ForEach(entry.text.components(separatedBy: "\n").prefix(5), id: \.self){ line in
                    if(line != ""){
                        Text(line)
                            .font(.footnote)
                            .lineLimit(1)
                            .padding(EdgeInsets(top: -4, leading: 0, bottom: -5, trailing: 0))
                        Divider()
                    }
                }
            }
            Spacer()
                Text("Last Updated: \(formattedLastUpdateTime(entry.date))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(alignment: .center)
            
        }.padding(EdgeInsets(top: 5, leading: -7, bottom: -3, trailing: -7))
    }
}

struct T8Widget: Widget {
    let kind: String = "T8Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                T8WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                T8WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    T8Widget()
} timeline: {
    SimpleEntry(date: .now, text: "1. Городская больница 4 (Ульянова)\n2. Стадион Саранск\n3. Энегльса\n4. Клуб строителей\n")
    SimpleEntry(date: .now, text: "Пример 2")
}
