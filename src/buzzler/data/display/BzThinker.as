package buzzler.data.display
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.system.ai.BzStateMachine;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	public class BzThinker extends BzElement
	{
		private	var _fsm:BzStateMachine;
		
		public function BzThinker(id:String, sets:BzSet, state:String, aabb:BzRectangle, think:IBzState, thinkGlobal:IBzState = null)
		{
			super(id, sets, state, aabb);

			_fsm = new BzStateMachine(this);
			_fsm.setCurrentState(think);
			_fsm.setGlobalState(thinkGlobal);
		}
		
		public	function getFSM():BzStateMachine
		{
			return _fsm;
		}
	}
}