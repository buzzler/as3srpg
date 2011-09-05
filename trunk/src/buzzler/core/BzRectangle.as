package buzzler.core
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.dns.AAAARecord;

	public class BzRectangle
	{
		private	var _x		:Number;
		private	var _y		:Number;
		private	var _z		:Number;
		private	var _width	:Number;
		private	var _height	:Number;
		private	var _depth	:Number;

		public function BzRectangle(x:Number, y:Number, z:Number, width:Number, height:Number, depth:Number)
		{
			_x		= x;
			_y		= y;
			_z		= z;
			_width	= width;
			_height	= height;
			_depth	= depth;
		}
		
		public	function set x(value:Number):void
		{
			;
		}
		
		public	function get x():Number
		{
			return _x;
		}
		
		public	function set y(value:Number):void
		{
			;
		}
		
		public	function get y():Number
		{
			return _y;
		}
		
		public	function set z(value:Number):void
		{
			;
		}
		
		public	function get z():void
		{
			return _z;
		}
		
		public	function set width(value:Number):void
		{
			;
		}
		
		public	function get width():Number
		{
			return _width;
		}
		
		public	function set height(value:Number):void
		{
			;
		}
		
		public	function get height():Number
		{
			return _height;
		}
		
		public	function set depth(value:Number):void
		{
			;
		}
		
		public	function get depth():Number
		{
			return _depth;
		}
		
		public	function set size(vector:Vector3D):void
		{
			;
		}
		
		public	function get size():Vector3D
		{
			;
		}
		
		public	function set top(value:Number):void
		{
			;
		}
		
		public	function get top():Number
		{
			;
		}
		
		public	function set bottom(value:Number):void
		{
			;
		}
		
		public	function get bottom():Number
		{
			;
		}
		
		public	function set left(value:Number):void
		{
			;
		}
		
		public	function get left():Number
		{
			;
		}
		
		public	function set right(value:Number):void
		{
			;
		}
		
		public	function get right():Number
		{
			;
		}
		
		public	function set ceil(value:Number):void
		{
			;
		}
		
		public	function get ceil():Number
		{
			;
		}
		
		public	function set floor(value:Number):void
		{
			;
		}
		
		public	function get floor():Number
		{
			;
		}
		
		public	function set topLeft(point:Point):void
		{
			;
		}
		
		public	function get topLeft():Point
		{
			;
		}
		
		public	function set topLeftCeil(vector:Vector3D):void
		{
			;
		}
		
		public	function get topLeftCeil():Vector3D
		{
			;
		}
		
		public	function set bottomRight(point:Point):void
		{
			;
		}
		
		public	function get bottomRight():Point
		{
			;
		}
		
		public	function set bottomRightFloor(vector:Vector3D):void
		{
			;
		}
		
		public	function get bottomRightFloor():Vector3D
		{
			;
		}
		
		public	function clone():BzRectangle
		{
			return new BzRectangle(_x, _y, _z, _width, _height, _depth);
		}
		
		public	function contains(x:Number, y:Number, z:Number):Boolean
		{
			;
		}
		
		public	function containsVector3D(vector:Vector3D):Boolean
		{
			;
		}
		
		public	function containsBzRectangle(rectangle:BzRectangle):Boolean
		{
			;
		}
		
		public	function equals(rectangle:BzRectangle):Boolean
		{
			;
		}
		
		public	function inflate(dx:Number, dy:Number, dz:Number):void
		{
			;
		}
		
		public	function inflateVector3D(vector:Vector3D):void
		{
			;
		}
		
		public	function intersection(rectangle:BzRectangle):BzRectangle
		{
			;
		}
		
		public	function intersects(rectangle:BzRectangle):Boolean
		{
			;
		}
		
		public	function isEmpty():Boolean
		{
			;
		}
		
		public	function offset(dx:Number, dy:Number, dz:Number):void
		{
			;
		}
		
		public	function offsetVector(vector:Vector3D):void
		{
			;
		}
		
		public	function setEmpty():void
		{
			;
		}
		
		public	function toString():void
		{
			;
		}
		
		public	function union(rectangle:BzRectangle):BzRectangle
		{
			;
		}
	}
}