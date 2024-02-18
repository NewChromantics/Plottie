//
//  ContentView.swift
//  Plottie
//
//  Created by Graham Reeves on 18/02/2024.
//

import SwiftUI
import SwiftData
import Lottie

struct ContentView: View 
{
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [Item]

	var document: LottieDocument
	//	gr: making this @State doesnt change the display when the contents change...
	@State var loadedAnimation : Lottie.LottieAnimation? = nil
	@State var loadingError : String?
	
	@MainActor
	func ReloadAnimation(reason:String)
	{
		Task()
		{
			await ReloadAnimationAsync(reason:reason)
		}
	}
	
	@MainActor
	func ReloadAnimationAsync(reason:String) async
	{
		print("ReloadAnimation... \(reason)")
		do
		{
			let fileContentsString = String(data: self.document.lottieFileData, encoding: .utf8)
			let data = fileContentsString!.data(using: .ascii)
			print("Loading anim... \(reason) x\(self.document.lottieFileData.count) bytes")
			//print(fileContentsString ?? "the data")
			loadedAnimation = try Lottie.LottieAnimation.from(data:self.document.lottieFileData)
			//loadedAnimation = try Lottie.LottieAnimation.from(data:data!)
			print("anim loaded. \(reason)")
			loadingError = "done! \(reason)"
			//animation = Lottie.LottieAnimation()
			//animation = LottieAnimation()//(from: data: document.lottieFileData)
		}
		catch
		{
			print("error loading anim; \(reason);  \(error.localizedDescription)")
			loadingError = error.localizedDescription
		}
	}

	var body: some View
	{
		//HSplitView()
		HStack()
		{
			LottieMetaView(document.lottie)
				.frame(minWidth:100,maxHeight: .infinity)
			
			VStack()
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
						
				//LottieView(animation: loadedAnimation )
				//LottieView(animation: .named("LottieLogo1") )
					.playing(loopMode: .loop)
					.resizable()
					//.background(.red)
					.frame(maxWidth:.infinity,maxHeight: .infinity)
					.onAppear()
					{
						//ReloadAnimation(reason:"onappear")
					}
					.onChange(of: document.lottieFileData)
					{
						//ReloadAnimation(reason:"data changed")
					}
					.task()
					{
						//await ReloadAnimationAsync(reason:"Task")
					}

				if loadingError != nil
				{
					Label("Failed to load animation \(loadingError!)", systemImage:"exclamationmark.triangle.fill")
						.frame(maxWidth:.infinity)
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

#Preview {
	
	
	ContentView(document:LottieDocument())
        .modelContainer(for: Item.self, inMemory: true)
}
