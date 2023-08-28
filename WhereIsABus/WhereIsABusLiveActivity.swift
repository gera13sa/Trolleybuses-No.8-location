//
//  WhereIsABusLiveActivity.swift
//  WhereIsABus
//
//  Created by Александр Герасимов on 28.08.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WhereIsABusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WhereIsABusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WhereIsABusAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WhereIsABusAttributes {
    fileprivate static var preview: WhereIsABusAttributes {
        WhereIsABusAttributes(name: "World")
    }
}

extension WhereIsABusAttributes.ContentState {
    fileprivate static var smiley: WhereIsABusAttributes.ContentState {
        WhereIsABusAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WhereIsABusAttributes.ContentState {
         WhereIsABusAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WhereIsABusAttributes.preview) {
   WhereIsABusLiveActivity()
} contentStates: {
    WhereIsABusAttributes.ContentState.smiley
    WhereIsABusAttributes.ContentState.starEyes
}
