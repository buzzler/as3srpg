package buzzler.data
{
	import flash.display.BitmapData;

	public class BzSheet
	{
		private	var _type	:String;
		private	var _north	:BzSprite;
		private	var _east	:BzSprite;
		private	var _south	:BzSprite;
		private	var _west	:BzSprite;
		
		public function BzSheet(type:String, north:BzSprite, east:BzSprite, south:BzSprite, west:BzSprite)
		{
			_type	= type;
			_north	= north;
			_east	= east;
			_south	= south;
			_west	= west;
		}
		
		public	function dispose():void
		{
			_north.dispose();
			_east.dispose();
			_south.dispose();
			_west.dispose();
			
			_north	= null;
			_east	= null;
			_south	= null;
			_west	= null;
		}
		
		public	function getType():String
		{
			return _type;
		}
		
		public	function getNorth():BzSprite
		{
			return _north;
		}
		
		public	function getEast():BzSprite
		{
			return _east;
		}
		
		public	function getSouth():BzSprite
		{
			return _south;
		}
		
		public	function getWest():BzSprite
		{
			return _west;
		}
	}
}