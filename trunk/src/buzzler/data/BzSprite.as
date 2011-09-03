package buzzler.data
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BzSprite
	{
		private	var _bitmapdata	:BitmapData;
		private	var _current	:int;
		private	var _totalframes:int;
		private	var _sprites	:Vector.<BitmapData>;
		private	var	_dest		:Point;
		private	var _offset		:Point;
		
		public	function BzSprite(source:BitmapData, width:int, height:int, centerX:int, centerY:int)
		{
			_bitmapdata	= new BitmapData(width, height);
			_sprites	= new Vector.<BitmapData>();
			_dest		= new Point();
			_offset		= new Point(centerX, centerY);
			
			var sprite:BitmapData;
			var dest:Point = new Point();
			var rect:Rectangle = new Rectangle(0, 0, width, height);
			for (rect.y = 0 ; rect.y < source.height ; rect.y += height)
			{
				for (rect.x = 0 ; rect.x < source.width ; rect.x += width)
				{
					sprite = new BitmapData(width, height);
					sprite.copyPixels(source, rect, dest);
					_sprites.push(sprite);
				}
			}
			
			_current = 0;
			_totalframes = _sprites.length;
		}
		
		public	function dispose():void
		{
			_bitmapdata.dispose();
			for each (var sprite:BitmapData in _sprites)
			{
				sprite.dispose();
			}
			
			_bitmapdata = null;
			_sprites = null;
		}
		
		public	function getBitmapData():BitmapData
		{
			return _bitmapdata;
		}
		
		public	function getTotalFrame():int
		{
			return _totalframes;
		}
		
		public	function getCurrentFrame():int
		{
			return _current;
		}
		
		public	function getOffset():Point
		{
			return _offset;
		}
		
		public	function drawNextFrame():void
		{
			var sprite:BitmapData = _sprites[_current];
			_bitmapdata.copyPixels(sprite, sprite.rect, _dest);
			_current = (_current + 1) % _totalframes;
		}
	}
}