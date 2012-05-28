package buzzler.data
{
	import flash.utils.Dictionary;

	public class BzSet
	{
		private	var _id		:String;
		private var _sheets	:Object;
		
		public function BzSet(id:String = "noname")
		{
			_id = id;
			_sheets = new Object();
		}
		
		public	function dispose():void
		{
			for each (var sheet:BzSheet in _sheets)
			{
				delete _sheets[sheet.getType()];
				sheet.dispose();
			}
			_sheets = null;
		}
		
		public	function addState(sheet:BzSheet):void
		{
			_sheets[sheet.getType()] = sheet;
		}
		
		public	function removeState(type:String):BzSheet
		{
			var backup:BzSheet = _sheets[type] as BzSheet;
			delete _sheets[type];
			return backup;
		}
		
		public	function getState(type:String):BzSheet
		{
			return _sheets[type] as BzSheet;
		}
		
		public	function containByType(type:String):Boolean
		{
			return (_sheets[type] != null);
		}
		
		public	function containByObject(sheet:BzSheet):Boolean
		{
			return (_sheets[sheet.getType()] != null);
		}
	}
}