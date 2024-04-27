import SwiftUI
import PopLottie


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
		List
		{
			MetaElementView("version",icon:"questionmark.square.fill",meta:"Version \(lottie.v)")
			MetaElementView("name", icon: "textformat.abc.dottedunderline",meta:"Name \(lottie.Name)")
			MetaElementView("size", icon: "square.resize",meta:"Size \(lottie.w)x\(lottie.h)")
			MetaElementView("ddd", icon: "questionmark.square.fill",meta:"ddd \(lottie.ddd)" )
			MetaElementView("layers",icon:"square.on.square",layers: lottie.layers)
			//MetaElementView("assets",icon:"square.3.layers.3d.down.left",assets: lottie.Assets)
		}
	}


}

#Preview {
	
	var meta = PopLottie.Root(Width: 100, Height: 100, Name: "Preview", DurationSeconds: 10)
	meta.layers = []
	//meta.layers?.append( LayerMeta(nm: "test", ind: 0, st: 0 ) )
	//meta.layers?.append( LayerMeta(nm: "test2", ind: 1, st: 2 ) )
	return LottieMetaView( meta )
}
