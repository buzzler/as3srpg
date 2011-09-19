package buzzler.data
{
	import flash.utils.Dictionary;

	public class BzSet
	{
		private	var _id		:String;
		private var _states	:Object;
		
		public function BzSet(id:String = "noname")
		{
			_id = id;
			_states = new Object();
		}
		
		public	function dispose():void
		{
			for each (var state:BzState in _states)
			{
				delete _states[state.getType()];
				state.dispose();
			}
			_states = null;
		}
		
		public	function addState(state:BzState):void
		{
			_states[state.getType()] = state;
		}
		
		public	function removeState(type:String):BzState
		{
			var backup:BzState = _states[type] as BzState;
			delete _states[type];
			return backup;
		}
		
		public	function getState(type:String):BzState
		{
			return _states[type] as BzState;
		}
		
		public	function containByType(type:String):Boolean
		{
			return (_states[type] != null);
		}
		
		public	function containByObject(state:BzState):Boolean
		{
			return (_states[state.getType()] != null);
		}
	}
}