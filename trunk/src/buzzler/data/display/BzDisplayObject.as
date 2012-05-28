package buzzler.data.display
{
	import buzzler.consts.BzTile;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Vector3D;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class BzDisplayObject extends Bitmap
	{
		private	var _element	:BzElement;
		private	var _rotated	:Boolean;
		private	var _rotation	:BzRotation;
		private	var _moved		:Boolean;
		private	var _rect		:BzRectangle;
		private	var _modified	:Boolean;
		private	var _sheet		:BzSheet;
		
		public function BzDisplayObject(element:BzElement)
		{
			super(null, PixelSnapping.NEVER, false);

			_element	= element;
			_rotated	= true;
			_rotation	= new BzRotation();
			_moved		= true;
			_rect		= new BzRectangle();
		}
		
		public	function get realX():Number
		{
			return super.x;
		}
		
		public	function get realY():Number
		{
			return super.y;
		}
		
		override public	function set x(value:Number):void
		{
			super.x = value - getBzSprite().getOffset().x;
		}
		
		override public	function get x():Number
		{
			return super.x + getBzSprite().getOffset().x;
		}
		
		override public	function set y(value:Number):void
		{
			super.y = value - getBzSprite().getOffset().y;
		}
		
		override public function get y():Number
		{
			return super.y + getBzSprite().getOffset().y;
		}
		
		public	function getBzRectangle():BzRectangle
		{
			return _rect;
		}
		
		public	function setLocalPosition(x:Number, y:Number, z:Number):void
		{
			_rect.x = x;
			_rect.y = y;
			_rect.z = z;
		}
		
		public	function getLocalPosition():Vector3D
		{
			return _rect.topLeftFloor;
		}
		
		public	function getGlobalPosition():Vector3D
		{
			return _element.getPosition();
		}
		
		public	function setLocalSize(width:int, height:int, depth:int):void
		{
			_rect.width = width;
			_rect.height = height;
			_rect.depth = depth;
		}
		
		public	function getLocalSize():Vector3D
		{
			return _rect.size;
		}
		
		public	function getGlobalSize():Vector3D
		{
			return _element.getBzRectangle().size;
		}
		
		public	function setLocalRotation(value:int):void
		{
			_rotation.setValue(value);
			
			/*if (Math.abs(_element.getBzRotation().getValue()-value) != 180)
			{
				;
			}*/
		}
		
		public	function getLocalRotation():BzRotation
		{
			return _rotation;
		}
		
		public	function getGlobalRotation():BzRotation
		{
			return _element.getBzRotation();
		}
		
		public	function updateState():void
		{
			_sheet = _element.getBzSheet();
			
			var sprite:BzSprite = getBzSprite();
			_element.getBzScene().getRenderer().reg(this, sprite);
		}
		
		public	function getBzSheet():BzSheet
		{
			return _sheet;
		}
		
		public	function getBzSprite():BzSprite
		{
			switch (_rotation.getValue())
			{
				case BzRotation.NORTH:
					return _sheet.getNorth();
				case BzRotation.EAST:
					return _sheet.getEast();
				case BzRotation.SOUTH:
					return _sheet.getSouth();
				case BzRotation.WEST:
					return _sheet.getWest();
				default:
					return _sheet.getNorth();	
			}
		}
		
		public	function getBzElement():BzElement
		{
			return _element;
		}
		
		public	function get tileX():Number
		{
			return _rect.x;
		}
		
		public	function get tileY():Number
		{
			return _rect.y;
		}
		
		public	function get tileZ():Number
		{
			return _rect.z;
		}
		
		public	function clear():void
		{
			_element = null;
		}
		
		public	function setStateFlag():void
		{
			_modified = true;
		}
		
		public	function getAndClearStateFlag():Boolean
		{
			var temp:Boolean = _modified;
			_modified = false;
			return temp;
		}
		
		public	function setRotateFlag():void
		{
			_rotated = true;
		}
		
		public	function getAndClearRotateFlag():Boolean
		{
			var temp:Boolean = _rotated;
			_rotated = false;
			return temp;
		}
		
		public	function setMoveFlag():void
		{
			_moved = true;
		}
		
		public	function getAndClearMoveFlag():Boolean
		{
			var temp:Boolean = _moved;
			_moved = false;
			return temp;
		}
	}
}