import SwiftUI
import PopLottie

func substring(_ str: String, _ start: Int, length : Int) -> String
{
	let startIndex = str.index(str.startIndex, offsetBy: start)
	let end = min( str.count, start+length-1 )
	let endIndex = str.index(str.startIndex, offsetBy: end)
	return String(str[startIndex..<endIndex])
}

//	to let these be selectable in a list, they need to be identifiable views
struct AnyMetaTreeView : View, Identifiable, Hashable
{
	static func == (lhs: AnyMetaTreeView, rhs: AnyMetaTreeView) -> Bool {
		return lhs.TreePath == rhs.TreePath
	}
	func hash(into hasher: inout Hasher) 
	{
		hasher.combine(TreePath)
	}
	
	var id : String	{	TreePath	}
	var TreePath : String
	{
		return "\(ParentKey)/\(ThisKey)"
	}

	var ParentKey : String
	var ThisKey : String
	var ThisValue : Any
	
	func LabelView(Meta:Mirror) -> some View
	{
		let TypeString = "\(type(of: ThisValue))"
		let LabelString = TreePath
		//let LabelString = "\(ThisKey)"
		return Label("\(LabelString) (\(TypeString))", systemImage: "square" )
			.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	var body : some View
	{
		let ThisMeta = Mirror(reflecting: ThisValue)
		
		
		if let ValueIsArray = ThisValue as? Array<Any>
		{
			DisclosureGroup()
			{
				//Text("I am array x\(ValueIsArray.count)")
				let Children = ValueIsArray
				//let colors: [Int] = [1,2,3]
				let ChildIndexes : [Int] = Array(ValueIsArray.indices)
				ForEach(ChildIndexes, id: \.hashValue)
				{
					ChildIndex in
					let ChildValue = ValueIsArray[ChildIndex]
					var ValueString = substring("\(ChildValue)", 0, length: 20 )
					//let ValueString = "Value"
					let TypeString = "\(type(of: ChildValue))"
					//Text("Hello \(Index) \(TypeString) \(ValueString)")

					let ChildMeta = Mirror(reflecting: ChildValue)
					//let ChildLabel = child.label ?? "no label"
					let ChildLabel = "\(TypeString) #\(ChildIndex)"
					
					AnyMetaTreeView( ParentKey: TreePath, ThisKey: ChildLabel, ThisValue: ChildValue)
					
					//Text("\(ChildLabel) children x\(ChildMeta.children.count)")
				}
			}
			label:
			{
				LabelView(Meta:ThisMeta)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		else if ( !ThisMeta.children.isEmpty )
		{
			DisclosureGroup()
			{
				//Text("Has children")
				let Children = Array(ThisMeta.children)
				ForEach(Children, id: \.label)
				{
					child in
				
						let ChildMeta = Mirror(reflecting: child.value)
						let ChildLabel = child.label ?? "no label"
						
						AnyMetaTreeView( ParentKey: TreePath, ThisKey: child.label ?? "no label", ThisValue: child.value)
							.frame(maxWidth: .infinity, alignment: .leading)
						/*
						Text("\(ChildLabel) children x\(ChildMeta.children.count)")
							.frame(maxWidth: .infinity, alignment: .leading)
						*/
					
				}
				
			}
			label:
			{
				LabelView(Meta:ThisMeta)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		else
		{
			LabelView(Meta:ThisMeta)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		
	
		/*
		let Properties = Array(mirror.children)
		ForEach( Properties, id: \.label)
		{
			child in
			let Key = child.label ?? "<NoKey>"
			let Value = String(describing: child.value)
			Text("Found child '\(Key)' with value '\(Value)'")
		}
		*/
	}
}


//	to let these be selectable in a list, they need to be identifiable views
struct LayerMetaView : View, Identifiable
{
	var id : UUID = UUID()
	var layer : LayerMeta
	
	var body : some View
	{
		DisclosureGroup()
		{
			//	reflect everything
			let mirror = Mirror(reflecting: layer)
			let Properties = Array(mirror.children)
			ForEach( Properties, id: \.label)
			{
				child in
				let Key = child.label ?? "<NoKey>"
				let Value = String(describing: child.value)
				Text("Found child '\(Key)' with value '\(Value)'")
			}
		}
		label:
		{
			Label("Layer \(layer.Name)", systemImage: "square" )
				.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}


//	to let these be selectable in a list, they need to be identifiable views
struct MetaElementView : View, Identifiable
{
	var id : UUID = UUID()
	var icon : String	//	can we use Image?
	var metaString : String? = nil
	var metaLayers : [LayerMeta]? = nil
	//var metaAssets : [AssetMeta]? = nil
	//var metaMarkers : [MarkerMeta]? = nil

	init(_ xid:String,icon:String,meta:String)
	{
		//self.id = id
		self.icon = icon
		self.metaString = meta
	}
	
	init(_ xid:String,icon:String,layers:[LayerMeta])
	{
		//self.id = id
		self.icon = icon
		self.metaLayers = layers
	}
	/*
	init(_ id:String,icon:String,assets:[AssetMeta])
	{
		//self.id = id
		//self.id = UUID()
		self.icon = icon
		self.metaAssets = assets
	}

	init(_ id:String,icon:String,markers:[MarkerMeta])
	{
		//self.id = id
		//self.id = UUID()
		self.icon = icon
		self.metaMarkers = markers
	}
*/
	var body : some View
	{
		if let meta = metaString
		{
			Label(meta, systemImage: icon)
				.textSelection(.enabled)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		
		if let layers = metaLayers
		{
			DisclosureGroup
			{
				ForEach(layers)
				{
					layer in
					LayerMetaView(layer:layer)
				}
			}
			
			label:
			{
				Label("Layers x\(layers.count)", systemImage: icon)
					.textSelection(.enabled)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		/*
		if let assets = metaAssets
		{
			DisclosureGroup()
			{
				ForEach(assets)
				{
					asset in
					Label("Asset \(asset.Name)", systemImage: "square" )
						.frame(alignment: .leading)
				}
			}
			label:
			{
				Label("Assets x\(assets.count)", systemImage: icon)
					.frame(alignment: .leading)
			}
			.frame(alignment: .leading)
		}
		
		if let markers = metaMarkers
		{
			DisclosureGroup()
			{
				ForEach(markers)
				{
					marker in
					Label("Marker \(marker.Name)", systemImage: "square" )
						.frame(alignment: .leading)
				}
			}
			label:
			{
				Label("Markers x\(markers.count)", systemImage: icon)
					.frame(alignment: .leading)
			}
			.frame(alignment: .leading)
		}
		 */
	}
}

struct LottieMetaView: View
{
	var lottie : PopLottie.Root
	@State var selection : UUID?
	@State var LayersExpanded : Bool = false
	@State var AssetsExpanded : Bool = false

	init(_ lottie:PopLottie.Root)
	{
		self.lottie = lottie
	}

		
	var body : some View
	{
		MetaTreeView(RootValue: lottie, RootLabel: "Animation")
	}
}



struct MetaTreeView: View
{
	var RootValue : Any
	var RootLabel : String
	@State var SelectedTreePath : Set<String> = ["/ROOT"]
	
	var body : some View
	{
		List(selection: $SelectedTreePath)
		{
			AnyMetaTreeView(ParentKey: "", ThisKey: "ROOT", ThisValue: RootValue)
				.frame(maxWidth: .infinity)
		}
		.frame(maxHeight: .infinity)
		//.toolbar { EditButton() }
		
		Text("Selected: \(SelectedTreePath.joined())")
		//Text("Selected: \(SelectedTreePath.count)")
	}
}


//	from https://developer.apple.com/documentation/swiftui/list#Refreshing-the-list-content
struct FileTreeView : View {
	
	struct FileItem: Hashable, Identifiable, CustomStringConvertible
	{
		//var id: Self { self }
		//var id : UUID = UUID()
		var id : String { name}
		var name: String
		var children: [FileItem]? = nil
		var description: String {
			switch children {
			case nil:
				return "📄 \(name)"
			case .some(let children):
				return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
			}
		}
	}
	let fileHierarchyData: [FileItem] = [
	  FileItem(name: "users", children:
		[FileItem(name: "user1234", children:
		  [FileItem(name: "Photos", children:
			[FileItem(name: "photo001.jpg"),
			 FileItem(name: "photo002.jpg")]),
		   FileItem(name: "Movies", children:
			 [FileItem(name: "movie001.mp4")]),
			  FileItem(name: "Documents", children: [])
		  ]),
		 FileItem(name: "newuser", children:
		   [FileItem(name: "Documents", children: [])
		   ])
		]),
		FileItem(name: "private", children: nil)
	]

	@State var Selection = ""
	
	var body: some View
	{
		List(fileHierarchyData, children: \.children, selection: $Selection)
		{
			item in
			Text(item.description)
		}
	}
}

	
#Preview {
	
	var Lottie = PopLottie.Root(Width: 100, Height: 100, Name: "Preview", DurationSeconds: 10)
	Lottie.layers = []
	Lottie.layers.append( LayerMeta(name:"test") )
	//meta.layers?.append( LayerMeta(nm: "test", ind: 0, st: 0 ) )
	//meta.layers?.append( LayerMeta(nm: "test2", ind: 1, st: 2 ) )
	//return LottieMetaView( meta )
	
	//return FileTreeView()
	
	
	return MetaTreeView(RootValue: Lottie, RootLabel: "Animation")
	.frame(minWidth: 100,minHeight: 200)
}
