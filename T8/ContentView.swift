//
//  ContentView.swift
//  T8
//
//  Created by Александр Герасимов on 26.08.2023.
//

import SwiftUI
import SwiftSoup
import WidgetKit

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
        for (i, td) in zip(busFind.indices, busFind) {
            let text = try td.text()
            textArray.append("(\(i+1)) "+text)
        }
        let finalString = textArray.joined(separator: "\n")
        
        return String("Троллейбусов на маршруте: "+numOfBuses+" шт.\n\n"+finalString)
        
    } catch let error {
        return String(error.localizedDescription)
    }
}


struct ContentView: View {
    @State var htmlTextDisplay = "–"
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(htmlTextDisplay)
                .font(.title2)
            Button("Где троллейбусы?!") {
                let htmlContent = GetHtml()
                let htmlText = ParseHtml(html: htmlContent)
                htmlTextDisplay = htmlText
                print("Done")
            }
            .font(.title)
            .padding()
            .bold()
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }.onDisappear() {
            WidgetCenter.shared.reloadTimelines(ofKind: "T8Widget")
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
