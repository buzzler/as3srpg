package buzzler.core
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		private	var _top	:Number;
		private var _bottom	:Number;
		private var _left	:Number;
		private var _right	:Number;
		private	var _ceil	:Number;
		private	var _floor	:Number;
		
		private	var _topleft		:Point;
		private	var _topleftfloor	:Vector3D;
		private	var _bottomright	:Point;
		private	var _bottomrightceil:Vector3D;
		private	var _size			:Vector3D;
		private	var _mass			:Number;

		public function BzRectangle(x:Number=0, y:Number=0, z:Number=0, width:Number=1, height:Number=1, depth:Number=1)
		{
			_topleft		= new Point();
			_topleftfloor	= new Vector3D();
			_bottomright	= new Point();
			_bottomrightceil= new Vector3D();
			_size			= new Vector3D();
			
			this.x	= x;
			this.y	= y;
			this.z	= z;
			
			this.width	= width;
			this.height	= height;
			this.depth	= depth;
		}
		
		public	function set x(value:Number):void
		{
			_x = _left = _topleft.x = _topleftfloor.x = value;
			_right = _bottomright.x = _bottomrightceil.x = _left + _width - 1;
		}
		
		public	function get x():Number
		{
			return _x;
		}
		
		public	function set y(value:Number):void
		{
			_y = _top = _topleft.y = _topleftfloor.y = value;
			_bottom = _bottomright.y = _bottomrightceil.y = _top + _height - 1;
		}
		
		public	function get y():Number
		{
			return _y;
		}
		
		public	function set z(value:Number):void
		{
			_z = _floor = _topleftfloor.z = value;
			_ceil = _bottomrightceil.z = _floor + _depth - 1;
		}
		
		public	function get z():Number
		{
			return _z;
		}
		
		public	function set width(value:Number):void
		{
			_width = _size.x = value;
			_right = _bottomright.x = _bottomrightceil.x = _left + _width - 1;
			_mass = _width * _height * _depth;
		}
		
		public	function get width():Number
		{
			return _width;
		}
		
		public	function set height(value:Number):void
		{
			_height = _size.y = value;
			_bottom = _bottomright.y = _bottomrightceil.y = _top + _height - 1;
			_mass = _width * _height * _depth;
		}
		
		public	function get height():Number
		{
			return _height;
		}
		
		public	function set depth(value:Number):void
		{
			_depth = _size.z = value;
			_ceil = _bottomrightceil.z = _floor + _depth - 1;
			_mass = _width * _height * _depth;
		}
		
		public	function get depth():Number
		{
			return _depth;
		}
		
		public	function set size(vector:Vector3D):void
		{
			width	= vector.x;
			height	= vector.y;
			depth	= vector.z;
		}
		
		public	function get size():Vector3D
		{
			return _size;
		}
		
		public	function get mass():Number
		{
			return _mass;
		}
		
		public	function set top(value:Number):void
		{
			y = value;
		}
		
		public	function get top():Number
		{
			return _top;
		}
		
		public	function get topi():int
		{
			return Math.round(_top);
		}
		
		public	function set bottom(value:Number):void
		{
			y = value - _height + 1;
		}
		
		public	function get bottom():Number
		{
			return _bottom;
		}
		
		public	function get bottomi():int
		{
			return Math.round(_bottom);
		}
		
		public	function set left(value:Number):void
		{
			x = value;
		}
		
		public	function get left():Number
		{
			return _left;
		}
		
		public	function get lefti():int
		{
			return Math.round(_left);
		}
		
		public	function set right(value:Number):void
		{
			x = value - _width + 1;
		}
		
		public	function get right():Number
		{
			return _right;
		}
		
		public	function get righti():int
		{
			return Math.round(_right);
		}
		
		public	function set ceil(value:Number):void
		{
			z = value - _depth + 1;
		}
		
		public	function get ceil():Number
		{
			return _ceil;
		}
		
		public	function get ceili():int
		{
			return Math.round(_ceil);
		}
		
		public	function set floor(value:Number):void
		{
			z = value;
		}
		
		public	function get floor():Number
		{
			return _floor;
		}
		
		public	function get floori():int
		{
			return Math.round(_floor);
		}
		
		public	function set topLeft(point:Point):void
		{
			top = point.y;
			left = point.x;
		}
		
		public	function get topLeft():Point
		{
			return _topleft;
		}
		
		public	function set topLeftFloor(vector:Vector3D):void
		{
			top = vector.y;
			left = vector.x;
			floor = vector.z;
		}
		
		public	function get topLeftFloor():Vector3D
		{
			return _topleftfloor;
		}
		
		public	function set bottomRight(point:Point):void
		{
			bottom = point.y;
			right = point.x;
		}
		
		public	function get bottomRight():Point
		{
			return _bottomright;
		}
		
		public	function set bottomRightCeil(vector:Vector3D):void
		{
			bottom = vector.y;
			right = vector.x;
			ceil = vector.z;
		}
		
		public	function get bottomRightCeil():Vector3D
		{
			return _bottomrightceil;
		}
		
		public	function clone():BzRectangle
		{
			return new BzRectangle(_x, _y, _z, _width, _height, _depth);
		}
		
		public	function contains(x:Number, y:Number, z:Number):Boolean
		{
			return (_x>=_left && _x<=_right && _y>=_top && _y<=_bottom && _z>=_floor && _z<=_ceil);
		}
		
		public	function containsVector3D(vector:Vector3D):Boolean
		{
			return contains(vector.x, vector.y, vector.z);
		}
		
		public	function containsBzRectangle(rectangle:BzRectangle):Boolean
		{
			return containsVector3D(rectangle.topLeftFloor) && containsVector3D(rectangle.bottomRightCeil);
		}
		
		public	function equals(rectangle:BzRectangle):Boolean
		{
			return (_x==rectangle.x && _y==rectangle.y && _z==rectangle.z && _width==rectangle.width && _height==rectangle.height && _depth==rectangle.depth);
		}
		
		public	function intersection(rectangle:BzRectangle):BzRectangle
		{
			if (intersects(rectangle))
			{
				var left:Number = Math.max(_left, rectangle.left);
				var right:Number = Math.min(_right, rectangle.right);
				var top:Number = Math.max(_top, rectangle.top);
				var bottom:Number = Math.min(_bottom, rectangle.bottom);
				var floor:Number = Math.max(_floor, rectangle.floor);
				var ceil:Number = Math.min(_ceil, rectangle.ceil);
				
				return new BzRectangle(left, top, floor, right-left, bottom-top, ceil-floor);
			}
			return new BzRectangle();
		}
		
		public	function intersects(rectangle:BzRectangle):Boolean
		{
			if (_left>rectangle.right || _top>rectangle.bottom || _floor>rectangle.ceil)
				return false;
			return true;
		}
		
		public	function isEmpty():Boolean
		{
			if (_x || _y || _z || _width || _height || _depth)
				return true;
			return false;
		}
		
		public	function offset(dx:Number, dy:Number, dz:Number):void
		{
			x += dx;
			y += dy;
			z += dz;
		}
		
		public	function offsetVector(vector:Vector3D):void
		{
			offset(vector.x, vector.y, vector.z);
		}
		
		public	function setEmpty():void
		{
			_x = _y = _z = _width = _height = _depth = 0;
			_top = _bottom = _left = _right = _ceil = _floor = 0;
		}
		
		public	function toString():String
		{
			var str:String = "BzRectangle(";
			str += _x.toString() + ", ";
			str += _y.toString() + ", ";
			str += _z.toString() + ", ";
			str += _width.toString() + ", ";
			str += _height.toString() + ", ";
			str += _depth.toString() + ")";
			return str;
		}
		
		public	function union(rectangle:BzRectangle):BzRectangle
		{
			var x:Number 	= Math.min(_x, rectangle.x);
			var y:Number 	= Math.min(_y, rectangle.y);
			var z:Number 	= Math.min(_z, rectangle.z);
			var width	:Number	= Math.max(_width, rectangle.width);
			var height	:Number	= Math.max(_height, rectangle.height);
			var depth	:Number	= Math.max(_depth, rectangle.depth);
			return new BzRectangle(x,y,z,width,height,depth);
		}
	}
}