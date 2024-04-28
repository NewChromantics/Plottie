//
//  PlottieApp.swift
//  Plottie
//
//  Created by Graham Reeves on 18/02/2024.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import PopLottie

@main
struct PlottieApp: App 
{
	var body: some Scene
	{
		
		WindowGroup
		{
			//	gr: want a better way of doing this...
			//LottieView(filename: URL(filePath: "/Volumes/Code/Plottie/ExampleAssets/Text.lottie.json") )
			LottieView(resourceFilename: "ExampleAssets/TextX.lottie")
		}
		
		
		DocumentGroup(newDocument: LottieDocument())
		{
			file in
				DocumentView(document: file.document)
		}
		 
		/*
		//	gr: can't get this right yet
		DocumentGroup(editing: .lottiejsDocument, migrationPlan: PlottieMigrationPlan.self)
		{
			ContentView(document:LottieDocument())
		}
		*/
	}
}


struct LottieDocument: FileDocument
{
	var lottie : PopLottie.Root
	var lottieFileData : Data		//	json to render the animation with
	
	static var readableContentTypes: [UTType]
	{
		[
			UTType.LottieJsonDocument
		]
	}

	init()
	{
		lottie = PopLottie.Root(Width: 100, Height: 100, Name:"New",DurationSeconds: 10)
		lottieFileData = Data()
	}
	
	init(Url:String)
	{
		let lottieFileContents = try! String.init(contentsOf: URL(string: Url)! )
		self.init(json: lottieFileContents)
	}

	init(BundleFilename:String)
	{
		let lottieFileContents = try! String.init(contentsOfFile: BundleFilename)
		self.init(json: lottieFileContents)
	}
	
	init(json:String)
	{
		lottieFileData = json.data(using: .ascii)!
		lottie = try! JSONDecoder().decode(PopLottie.Root.self, from: lottieFileData)
	}
	
	init(configuration: ReadConfiguration) throws
	{
		do
		{
			let fileContents = configuration.file.regularFileContents
			if ( fileContents == nil )
			{
				throw CocoaError(.fileReadUnknown)
			}
			let fileContentsData = fileContents!
			lottieFileData = fileContentsData
			let fileContentsString = String(data: fileContentsData, encoding: .utf8)
			//print(fileContentsString)
			lottie = try JSONDecoder().decode(PopLottie.Root.self, from: fileContentsData)
		}
		catch
		{
			throw CocoaError(.fileReadCorruptFile)
		}
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper
	{
		//let data = text.data(using: .utf8)!
		//return .init(regularFileWithContents: data)
		throw CocoaError(.fileWriteUnknown)
	}
}


extension UTType {
    static var LottieJsonDocument: UTType {
        UTType(importedAs: "com.newchromantics.lottiejson")
    }
}

struct PlottieMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        PlottieVersionedSchema.self,
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct PlottieVersionedSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        Item.self,
    ]
}
