//
//  WhereIsTheBus.swift
//  WhereIsTheBus
//
//  Created by Александр Герасимов on 28.08.2023.
//

import WidgetKit
import SwiftUI
import SwiftSoup

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func GetHtml() -> String {
        do {
            let myURL = URL(string: "https://ru.busti.me/saransk/trolleybus-8/")
            let htmlContent = try String(contentsOf: myURL!)
            return htmlContent
        } catch let error{
            print(error)
        }
        return "Error"
    }
    func ParseHtml(html: String) -> String {
        do{
            let doc: Document = try SwiftSoup.parse(html)
            
            let numOfBuses = String(try doc.select("table[id='dsel'] tr td").get(0).text().first!.wholeNumberValue!)
            
            let busFind = try doc.select("td:has(img)")
            var textArray: [String] = []
            for td in busFind {
                let text = try td.text()
                textArray.append(text)
            }
            let finalString = textArray.joined(separator: "\n")
            
            return String("Всего на маршруте: "+numOfBuses+" шт.\n\n"+finalString)
            
        } catch let error {
            return String(error.localizedDescription)
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct WhereIsTheBusEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct WhereIsTheBus: Widget {
    let kind: String = "WhereIsTheBus"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WhereIsTheBusEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WhereIsTheBusEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    WhereIsTheBus()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
