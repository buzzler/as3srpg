package buzzler.data
{
	
	import buzzler.data.display.BzElement;
	import buzzler.system.BzElementDetector;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class BzVoxel
	{
		private	static const	FREE	:uint		= 0;
		private	static const	FILLED	:uint		= 1;
		
		private	var _map		:BzElementDetector;
		private	var _type		:uint;
		private	var	_parent		:BzVoxel;
		private	var _g			:Number;
		private	var _f			:Number;
		private	var _position	:Vector3D;
		private	var _elements	:Vector.<BzElement>;
		
		public function BzVoxel(map:BzElementDetector, x:int, y:int, z:int)
		{
			_map		= map;
			_type		= FREE;
			_position	= new Vector3D(x, y, z);
			_g			= 0;
			_f			= 0;
			_parent		= null;
			_elements	= new Vector.<BzElement>();
		}
		
		public	function get map():BzElementDetector
		{
			return _map;
		}
		
		public	function get x():Number
		{
			return _position.x;
		}
		
		public	function get y():Number
		{
			return _position.y;
		}
		
		public	function get z():Number
		{
			return _position.z;
		}
		
		public	function get g():Number
		{
			return _g;
		}
		
		public	function get f():Number
		{
			return _f;
		}
		
		public	function addBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index < 0)
			{
				_elements.push(element);
			}
			
			if (_elements.length > 0)
			{
				_type = FILLED;
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
			{
				_elements.splice(index, 1);
			}
			
			if (_elements.length == 0)
			{
				_type = FREE;
			}
		}
		
		public	function getBzElements():Vector.<BzElement>
		{
			return _elements;
		}
		
		public	function setParent(parent:BzVoxel, g:Number, f:Number):void
		{
			_parent = parent;
			_g = g;
			_f = f;
		}
		
		public	function getParent():BzVoxel
		{
			return _parent;
		}
		
		public	function getPosition():Vector3D
		{
			return _position;
		}
		
		public	function isThroughable():Boolean
		{
			return (_type == FREE);
		}
		
		public	function isWalkable():Boolean
		{
			var floor:BzVoxel = _map.getBzVoxel(_position.x, _position.y, _position.z-1);
			
			if ((_type == FREE) && floor && (floor._type == FILLED))
				return true;
			else
				return false;
		}
		
		public	function reset():void
		{
			_g = 0;
			_f = 0;
			_parent = null;
		}
		
		public	function clear():void
		{
			_type = FREE;
			_elements.splice(0, _elements.length);
			reset();
		}
		
		public function toString():String
		{
			return _position.toString();
		}
	}
}