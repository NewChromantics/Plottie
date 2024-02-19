//
//  ContentView.swift
//  Plottie
//
//  Created by Graham Reeves on 18/02/2024.
//

import SwiftUI
import SwiftData
import Lottie



public extension Color
{
	var controlColor : Color
	{
#if os(macOS)
		return Color(NSColor.controlColor)
#else
		return Color(UIColor.tertiarySystemFill)
#endif
	}
}


struct ContentView: View
{
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [Item]

	var document: LottieDocument
	//	gr: making this @State doesnt change the display when the contents change...
	//@State var loadedAnimation : Lottie.LottieAnimation? = nil
	@State var loadingError : String?
	@State var playbackFrameTime : Lottie.AnimationFrameTime = 0

	var body: some View
	{
		//HSplitView()
		HStack()
		{
			LottieMetaView(document.lottie)
				.frame(minWidth:100,maxHeight: .infinity)
			
			VStack()
			{
				if self.document.lottieFileData.count > 0
				{
					LottieView
					{
						//Lottie.LottieAnimation.named("ExampleAnimation")
						try! Lottie.LottieAnimation.from(data: self.document.lottieFileData)
					}
					placeholder:
					{
						Text("Loading...")
					}
					.playing(loopMode: .loop)
					.getRealtimeAnimationFrame($playbackFrameTime)
					.frame(maxWidth:.infinity,maxHeight: .infinity)
				}
				
				Label("Time \(playbackFrameTime)", systemImage: "clock.fill")
					.padding(5)
					.frame(maxWidth:.infinity,alignment: .leading)

				if loadingError != nil
				{
					Label("Failed to load animation \(loadingError!)", systemImage:"exclamationmark.triangle.fill")
						.padding(5)
						.frame(maxWidth:.infinity,alignment: .leading)
				}
			}
			
		}
		.frame(maxWidth:.infinity,maxHeight: .infinity)
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


let ExampleJson = """
{"v":"5.6.3","fr":29.9700012207031,"ip":0,"op":60.0000024438501,"w":1920,"h":1080,"nm":"Comp 1","ddd":0,"assets":[],"layers":[{"ddd":0,"ind":1,"ty":4,"nm":"Shape Layer 1","sr":1,"ks":{"o":{"a":0,"k":100,"ix":11},"r":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[0]},{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":23,"s":[90]},{"t":51.0000020772726,"s":[182]}],"ix":10},"p":{"a":0,"k":[960,540,0],"ix":2},"a":{"a":0,"k":[0,0,0],"ix":1},"s":{"a":0,"k":[100,100,100],"ix":6}},"ao":0,"shapes":[{"ty":"gr","it":[{"ty":"rc","d":1,"s":{"a":0,"k":[317.004,317.004],"ix":2},"p":{"a":0,"k":[0,0],"ix":3},"r":{"a":0,"k":0,"ix":4},"nm":"Rectangle Path 1","mn":"ADBE Vector Shape - Rect","hd":false},{"ty":"st","c":{"a":0,"k":[1,1,1,1],"ix":3},"o":{"a":0,"k":100,"ix":4},"w":{"a":0,"k":2,"ix":5},"lc":1,"lj":1,"ml":4,"bm":0,"nm":"Stroke 1","mn":"ADBE Vector Graphic - Stroke","hd":false},{"ty":"fl","c":{"a":0,"k":[1,0,0,1],"ix":4},"o":{"a":0,"k":100,"ix":5},"r":1,"bm":0,"nm":"Fill 1","mn":"ADBE Vector Graphic - Fill","hd":false},{"ty":"tr","p":{"a":0,"k":[-36.316,-75.425],"ix":2},"a":{"a":0,"k":[0,0],"ix":1},"s":{"a":0,"k":[100,100],"ix":3},"r":{"a":0,"k":0,"ix":6},"o":{"a":0,"k":100,"ix":7},"sk":{"a":0,"k":0,"ix":4},"sa":{"a":0,"k":0,"ix":5},"nm":"Transform"}],"nm":"Rectangle 1","np":3,"cix":2,"bm":0,"ix":1,"mn":"ADBE Vector Group","hd":false}],"ip":0,"op":61.0000024845809,"st":0,"bm":0}],"markers":[]}
"""
let ExampleDocument = LottieDocument(json:ExampleJson)

#Preview 
{
	ContentView(document:ExampleDocument)
		.modelContainer(for: Item.self, inMemory: true)
}
