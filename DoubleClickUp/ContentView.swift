//
//  ContentView.swift
//  DoubleClickUp
//
//  Created by Justin Xin on 2023/01/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var leftURL: String = "https://app.clickup.com"
    @State var rightURL: String = "https://app.clickup.com"
    @State var data: [LeftSideRightSide] = []
    @State var selectedDataID: LeftSideRightSide.ID?
    @State var selectedDataIndex: Int = -1
    
    var body: some View {
        VStack(spacing: 4.0) {
            HStack(spacing: 4.0) {
                VStack(spacing: 4.0) {
                    TextField(text: $leftURL) {
                        Text("URL")
                    }
                    .onChange(of: selectedDataID) { _ in
                        if let selectedDataID = (selectedDataID),
                           let selectedData = data.first(where: {$0.id == selectedDataID.description}) {
                            leftURL = selectedData.leftSide
                            selectedDataIndex = data.firstIndex(where: {$0.id == selectedDataID.description}) ?? -1
                        }
                    }
                    WebView(url: leftURL)
                }
                VStack(spacing: 4.0) {
                    TextField(text: $rightURL) {
                        Text("URL")
                    }
                    .onChange(of: selectedDataID) { _ in
                        if let selectedDataID = (selectedDataID),
                           let selectedData = data.first(where: {$0.id == selectedDataID.description}) {
                            rightURL = selectedData.rightSide
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(rightURL, forType: .string)
                        }
                    }
                    WebView(url: rightURL)
                }
            }
            HStack(spacing: 4.0) {
                Button {
                    let openFileDialog = NSOpenPanel()
                    openFileDialog.canChooseDirectories = false
                    openFileDialog.allowedContentTypes = [.text]
                    if openFileDialog.runModal() == .OK {
                        let fileURL = openFileDialog.url
                        do {
                            let contents = try String(contentsOf: fileURL!, encoding: .utf8)
                            for line in contents.components(separatedBy: CharacterSet.newlines) {
                                let columns = line.components(separatedBy: CharacterSet(charactersIn: ","))
                                if columns.count == 2 {
                                    let newData = LeftSideRightSide(id: columns[0] + columns[1], leftSide: columns[0], rightSide: columns[1])
                                    data.append(newData)
                                }
                            }
                            print("Loaded \(data.count) entries.")
                        } catch {
                            print("Could not read CSV file.")
                        }
                    }
                } label: {
                    Text("Load CSV")
                }
                Spacer()
                Button {
                    if selectedDataIndex > 0 && data.count != 0 {
                        selectedDataIndex -= 1
                        selectedDataID = data[selectedDataIndex].id
                    }
                } label: {
                    Text("« Previous")
                }
                Button {
                    if selectedDataIndex < data.count - 1 && data.count != 0 {
                        selectedDataIndex += 1
                        selectedDataID = data[selectedDataIndex].id
                    }
                } label: {
                    Text("Next »")
                }
                Spacer()
            }
            Table(data, selection: $selectedDataID) {
                TableColumn("Left Side Task", value: \.leftSide)
                TableColumn("Right Side Task", value: \.rightSide)
            }
            .frame(height: 200.0)

        }
        .padding(4.0)
    }
}
