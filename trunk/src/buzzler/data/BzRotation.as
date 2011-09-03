package buzzler.data
{
	import flash.geom.Vector3D;

	public class BzRotation
	{
		public	static const NORTH	:int = 0;
		public	static const EAST	:int = 90;
		public	static const SOUTH	:int = 180;
		public	static const WEST	:int = 270;
		
		private	var _value:int;
		
		public	function BzRotation(value:int = BzRotation.NORTH):void
		{
			setValue(value);
		}
		
		public	function getValue():int
		{
			return _value;
		}
		
		public	function setValue(value:int):void
		{
			_value = value;
			restrict();
		}
		
		public	function add(rotation:BzRotation):BzRotation
		{
			return new BzRotation(_value + rotation.getValue());
		}
		
		public	function subtract(rotation:BzRotation):BzRotation
		{
			return new BzRotation(_value - rotation.getValue());
		}
		
		public	function clone():BzRotation
		{
			return new BzRotation(_value);
		}
		
		private	function restrict():void
		{
			while (_value < 0)
			{
				_value += 360;
			}

			_value = _value % 360;
		}
	}
}