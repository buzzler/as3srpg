package buzzler.data.display
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.system.ai.IBzState;
	
	public class BzUnit extends BzThinker implements iBzTouchable
	{
		private	var _touched:Boolean;
		
		public function BzUnit(id:String, sets:BzSet, state:String, aabb:BzRectangle, think:IBzState, thinkGlobal:IBzState=null)
		{
			_touched = false;

			super(id, sets, state, aabb, think, thinkGlobal);
		}
		
		public function setTouchFlag():void
		{
			_touched = true;
		}
		
		public function getTouchFlag():Boolean
		{
			return _touched;
		}
		
		public function clearTouchFlag():void
		{
			_touched = false;
		}
	}
}