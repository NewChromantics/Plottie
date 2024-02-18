//
//  ContentView.swift
//  Plottie
//
//  Created by Graham Reeves on 18/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

	var document: LottieDocument
	
    var body: some View 
	{
		//HSplitView()
		//{
			LottieMetaView(document.lottie)
		//}
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
	
	
	ContentView(document:LottieDocument())
        .modelContainer(for: Item.self, inMemory: true)
}
