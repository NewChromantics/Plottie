//
//  PlottieApp.swift
//  Plottie
//
//  Created by Graham Reeves on 18/02/2024.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct PlottieApp: App {
    var body: some Scene {
		
		DocumentGroup(newDocument: LottieDocument()) 
		{
			file in
				ContentView(document: file.document)
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
	var lottie : LottieMeta
	var lottieFileData : Data		//	json to render the animation with
	
	static var readableContentTypes: [UTType]
	{
		[
			UTType.LottieJsonDocument
		]
	}

	init()
	{
		lottie = LottieMeta()
		lottieFileData = Data()
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
			lottie = try! JSONDecoder().decode(LottieMeta.self, from: fileContentsData)
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
