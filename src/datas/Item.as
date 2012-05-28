package datas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Item
	{
		private	var _id			:String;
		private	var _name		:String;
		private	var _description:String;
		private	var _image		:BitmapData;
		private	var _type		:uint;
		private	var _performance:Performance;
		private	var _value		:uint;
		
		public function Item(id:String, name:String, description:String, image:BitmapData, type:uint, performance:Performance, value:uint)
		{
			_id			= id;
			_name		= name;
			_description= description;
			_image		= image;
			_type		= type;
			_performance= performance;
			_value		= value;
		}
		
		public	function get id():String
		{
			return _id;
		}
		
		public	function get name():String
		{
			return _name;
		}
		
		public	function get description():String
		{
			return _description;
		}
		
		public	function get image():BitmapData
		{
			return _image;
		}
		
		public	function get type():uint
		{
			return _type;
		}
		
		public	function get value():uint
		{
			return _value;
		}
		
		public	function get performance():Performance
		{
			return _performance;
		}
		
		public	static function generateFromXML(xml:XML):Item
		{
			var id:String = xml.@id;
			var name:String = xml.@name;
			var desc:String = xml.@description;
			var type:uint = parseInt( xml.@type.toString() );
			var performance:Performance = Performance.generateByXML( xml.PERFORMANCE[0] );
			var value:uint = parseInt( xml.@value.toString() );
			
			return new Item(id, name, desc, new BitmapData(1,1), type, performance, value);
		}
	}
}