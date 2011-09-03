package buzzler.data
{
	import buzzler.consts.BzTile;
	
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
		private	var _position	:Vector3D;
		private	var _modified	:Boolean;
		private	var _state		:BzState;
		
		public function BzDisplayObject(element:BzElement)
		{
			var cube:RedCube = new RedCube();
			var bmp:BitmapData = new BitmapData(cube.width, cube.height, true, 0x0);
			bmp.draw(cube);
			super(bmp, PixelSnapping.NEVER, false);

			_element	= element;
			_rotated	= true;
			_rotation	= new BzRotation();
			_moved		= true;
			_position	= new Vector3D();
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
		
		public	function setLocalPosition(x:Number, y:Number, z:Number):void
		{
			_position.x = x;
			_position.y = y;
			_position.z = z;
		}
		
		public	function getLocalPosition():Vector3D
		{
			return _position;
		}
		
		public	function getGlobalPosition():Vector3D
		{
			return _element.getPosition();
		}
		
		public	function setLocalRotation(value:int):void
		{
			_rotation.setValue(value);
		}
		
		public	function getLocalRotation():BzRotation
		{
			return _rotation;
		}
		
		public	function getGlobalRotation():BzRotation
		{
			return _element.getRotation();
		}
		
		public	function updateState():void
		{
			_state = _element.getState();
			bitmapData = getBzSprite().getBitmapData();
			
			// 통합 draw manager에 현제 상태를 등록, 이전 상태 제거, bitmap blitting
		}
		
		public	function getBzState():BzState
		{
			return _state;
		}
		
		public	function getBzSprite():BzSprite
		{
			switch (_rotation.getValue())
			{
				case BzRotation.NORTH:
					return _state.getNorth();
				case BzRotation.EAST:
					return _state.getEast();
				case BzRotation.SOUTH:
					return _state.getSouth();
				case BzRotation.WEST:
					return _state.getWest();
				default:
					return _state.getNorth();	
			}
		}
		
		public	function getBzElement():BzElement
		{
			return _element;
		}
		
		public	function get tileX():Number
		{
			return _position.x;
		}
		
		public	function get tileY():Number
		{
			return _position.y;
		}
		
		public	function get tileZ():Number
		{
			return _position.z;
		}
		
		public	function clear():void
		{
			_element = null;
			_position = null;
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