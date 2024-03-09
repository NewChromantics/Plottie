//	spec is readable here
//	https://lottiefiles.github.io/lottie-docs/breakdown/bouncy_ball/

struct Property : Identifiable
{
	var id: String { return key }
	var key : String
	var value : String
	
	init(_ key: String,_ value: String)
	{
		self.key = key
		self.value = value
	}
}

struct AssetMeta: Decodable, Identifiable
{
	public var id : String
	public var w : Int
	public var h : Int
	public var u : String
	public var p : String
	public var Folder : String	{	return u	}
	public var Name : String	{	return p	}
}

struct TransformMeta: Decodable
{
	public var id : String
	public var w : Int
	public var h : Int
	public var u : String
	public var p : String
	public var Folder : String	{	return u	}
	public var Name : String	{	return p	}
}



struct LayerMeta: Decodable, Identifiable
{
	//	identifiable
	var id: Int { return LayerId }
	
	var Properties : [Property]
	{
		return [
			Property("FirstKeyframe",String(FirstKeyframe)),
			Property("LastKeyframe",String(LastKeyframe)),
			Property("Name",Name),
			Property("ResourceId",ResourceId),
			Property("Name",Name),
			Property("LayerId",String(LayerId)),
			Property("StartTime",String(StartTime))
		]
	}
/*
	enum CodingKeys : String, CodingKey
	{
		case ip
		//case FirstKeyframe = "ip"
	}
	*/
	public var ip : Double = 0
	public var FirstKeyframe : Double	{	return ip	}
	public var op : Double = 10
	public var LastKeyframe : Double	{	return op	}
	
	public var nm : String
	public var Name : String		{	return nm	}
	public var refId : String?
	public var ResourceId : String	{	return refId ?? ""	}
	public var ind : Int
	public var LayerId : Int	{	return ind	}
	public var st : Double
	public var StartTime : Double	{	return st	}
}

struct MarkerMeta: Decodable, Identifiable
{
	public var cm : String
	public var id : String		{ return Name }
	public var Name : String	{	return cm	}
	public var tm : Int
	public var Frame : Int	{	return tm	}
	public var dr : Int
}

//	root json
struct LottieMeta: Decodable
{
	public var v:String = "5.9.2"
	public var fr:Double = 30
	public var ip:Double = 0
	public var FirstKeyframe : Double	{	return ip;	}
	public var op:Double = 10
	public var LastKeyframe : Double	{	return op;	}
	public var w:Int = 100
	public var h:Int = 100
	public var nm:String? = "Lottie File"
	public var Name : String	{	return nm ?? "Unnamed";	}
	public var ddd:Int = 0	//	not sure what this is
		
	var assets : [AssetMeta]?
	var layers : [LayerMeta]?
	var markers : [MarkerMeta]?

	public var Assets : [AssetMeta]	{	return assets ?? []	}
	public var Layers : [LayerMeta]	{	return layers ?? []	}
	public var Markers : [MarkerMeta]	{	return markers ?? []	}
	
	init()
	{
	}

}
