package datas
{
	public class Collection
	{
		private	var _hash:Object;
		
		public	function Collection()
		{
			_hash = new Object();
		}
		
		public	function getHashMap():Object
		{
			return _hash;
		}
		
		public	function getItemById(id:String):Object
		{
			if (!id)
				return null;
			else
				return _hash[id];
		}
		
		public	static function generateFromXMLList(xmllist:XMLList, generator:Function):Collection
		{
			var result:Collection = new Collection();
			
			for each (var x:XML in xmllist)
			{
				result._hash[x.@id] = generator(x) as Object;
			}
			
			return result;
		}
	}
}