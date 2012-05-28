package buzzler.data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;

	public class BzSprite
	{
		private	var _width		:int;
		private	var _height		:int;
		private	var _loop		:Boolean;
		private	var _bitmapdata	:BitmapData;
		private	var _current	:int;
		private	var _totalframes:int;
		private	var _sprites	:Vector.<BitmapData>;
		private	var	_dest		:Point;
		private	var _offset		:Point;
		private	var _speed		:Number;
		private var _speed_sum	:Number;
		private var _direction	:int;
		private	var _referers	:Vector.<Bitmap>;
		private	var _refererOff	:Vector.<int>;
		
		public	function BzSprite(source:BitmapData, width:int, height:int, centerX:int, centerY:int, speed:Number = 1.0, autoreverse:Boolean = false, loop:Boolean = true)
		{
			_width		= width;
			_height		= height;
			_loop		= loop;
			_bitmapdata	= new BitmapData(width, height);
			_current	= 0;
			_sprites	= new Vector.<BitmapData>();
			_dest		= new Point();
			_offset		= new Point(centerX, centerY);
			_referers	= new Vector.<Bitmap>();
			_refererOff	= new Vector.<int>();
			_speed		= speed;
			_speed_sum	= 0;
			_direction	= 1;
			
			sliceSource(source, autoreverse);
		}
		
		private	function sliceSource(source:BitmapData, autoreverse:Boolean):void
		{
			var sprite:BitmapData;
			var dest:Point = new Point();
			var rect:Rectangle = new Rectangle(0, 0, _width, _height);
			for (rect.y = 0 ; rect.y < source.height ; rect.y += _height)
			{
				for (rect.x = 0 ; rect.x < source.width ; rect.x += _width)
				{
					sprite = new BitmapData(_width, _height);
					sprite.copyPixels(source, rect, dest);
					_sprites.push(sprite);
				}
			}
			
			if (_sprites.length == 1)
			{
				_bitmapdata.copyPixels(_sprites[0], _sprites[0].rect, _dest);
			}
			else if (autoreverse)
			{
				var total:int = _sprites.length;
				for (var i:int = total-2 ; i >= 0 ; i--)
				{
					_sprites.push(_sprites[i]);
				}
			}
			
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
		
		public	function isSingle():Boolean
		{
			return (_totalframes==1);
		}
		
		public	function getTotalFrame():int
		{
			return _totalframes;
		}
		
		public	function getOffset():Point
		{
			return _offset;
		}
		
		public	function addReferer(bitmap:Bitmap):void
		{
			var index:int = _referers.indexOf(bitmap);
			if (index < 0)
			{
				_referers.push(bitmap);
				_refererOff.push(_current);
				bitmap.bitmapData = _bitmapdata;
			}
		}
		
		public	function removeReferer(bitmap:Bitmap):void
		{
			var index:int = _referers.indexOf(bitmap);
			if (index >= 0)
			{
				_referers.splice(index, 1);
				_refererOff.splice(index, 1);
//				bitmap.bitmapData = null;
			}
		}
		
		public	function containReferer(bitmap:Bitmap):Boolean
		{
			var index:int = _referers.indexOf(bitmap);
			return (index >= 0);
		}
		
		public	function getReferers():int
		{
			return _referers.length;
		}
		
		public	function getCurrentFrame(bitmap:Bitmap):int
		{
			var index:int = _referers.indexOf(bitmap);
			if (index >= 0)
			{
				var frame:int = _current - _refererOff[index];
				if (frame < 0)
				{
					frame += _totalframes;
				}
				return frame;
			}
			else
			{
				throw new Error("can't found specified referer");
			}
		}
		
		public	function drawNextFrame():void
		{
			/*if (getReferers() > 0)
			{
				var sprite:BitmapData = _sprites[_current];
				_bitmapdata.copyPixels(sprite, sprite.rect, _dest);
				_speed_sum = (_speed_sum + _speed*_direction) % _totalframes;
				_current = int(_speed_sum);
			}*/
			
			var removes:Vector.<int> = new Vector.<int>();
			for (var i:int = 0 ; i < _referers.length ; i++) 
			{
				var referer:Bitmap = _referers[i];
				var frame:int = _current - _refererOff[i];
				if (frame < 0)
				{
					frame += _totalframes;
				}

				referer.bitmapData = _sprites[frame];
				
				if ((frame == (_totalframes-1)) && (!_loop))
				{
					removes.push(i);
				}
			}
			
			for (i = removes.length-1 ; i >= 0 ; i--)
			{
				removeReferer(_referers[removes[i]]);
			}
			_speed_sum = (_speed_sum + _speed*_direction) % _totalframes;
			_current = int(_speed_sum);
		}
	}
}