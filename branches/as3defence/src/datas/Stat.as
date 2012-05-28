package datas
{
	public class Stat
	{
		private	var _minimum:int;
		private	var _maximum:int;
		private	var _value	:int;
		
		public function Stat(value:int = 0, min:int = 0 , max:int = 0)
		{
			this._minimum	= min;
			this._maximum	= max;
			this.value		= value;
		}
		
		public	function clone():Stat
		{
			return new Stat(_value, _minimum, _maximum);
		}
		
		public	function get minimum():int
		{
			return _minimum;
		}
		
		public	function set minimum(newValue:int):void
		{
			_minimum = Math.min(newValue, _maximum);
		}
		
		public	function get maxumum():int
		{
			return _maximum;
		}
		
		public	function set maximum(newValue:int):void
		{
			_maximum = Math.max(newValue, _minimum);
		}
		
		public	function get value():int
		{
			return _value;
		}
		
		public	function set value(newValue:int):void
		{
			_value = Math.max(Math.min(newValue,_maximum) , _minimum);
		}
		
		public	function add(operand:Stat):Stat
		{
			var min:int = _minimum + operand._minimum;
			var max:int = _maximum + operand._maximum;
			var val:int = _value + operand._value;
			
			return new Stat(val, min, max);
		}
		
		public	function subtract(operand:Stat):Stat
		{
			var min:int = _minimum - operand._minimum;
			var max:int = _maximum - operand._maximum;
			var val:int = _value - operand._value;
			
			return new Stat(val, min, max);
		}
		
		public	function multiply(operand:Stat):Stat
		{
			var min:int = _minimum * operand._minimum;
			var max:int = _maximum * operand._maximum;
			var val:int = _value * operand._value;
			
			return new Stat(val, min, max);
		}
		
		public	function divide(operand:Stat):Stat
		{
			var min:int = _minimum / operand._minimum;
			var max:int = _maximum / operand._maximum;
			var val:int = _value / operand._value;
			
			return new Stat(val, min, max);
		}
		
		public	static function generateByXML(source:XML):Stat
		{
			var val:int = parseInt(source.@value);
			var min:int = parseInt(source.@min);
			var max:int = parseInt(source.@max);
			
			return new Stat(val, min, max);
		}
	}
}
