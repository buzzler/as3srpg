package buzzler.system.ai
{
	public class BzStateMachine
	{
		private	var _owner		:Object;
		private	var _localState	:IBzState;
		private	var _globalState:IBzState;
		private	var _prevState	:Vector.<IBzState>;
		
		public function BzStateMachine(owner:Object)
		{
			if (owner)
			{
				_owner			= owner;
				_localState		= null;
				_globalState	= null;
				_prevState		= new Vector.<IBzState>();
			}
			else
			{
				throw new Error("parameter 'owner' is required!");
			}
		}
		
		public	function setCurrentState(state:IBzState):void
		{
			_localState = state;
		}
		
		public	function setGlobalState(state:IBzState):void
		{
			_globalState = state;
		}
		
		public	function getCurrentState():IBzState
		{
			return _localState;
		}
		
		public	function getGlobalState():IBzState
		{
			return _globalState;
		}
										 
		public	function changeState(state:IBzState, interruped:Boolean = false):Boolean
		{
			if (_localState === state)
				return false;

			if (_localState)
			{
				_localState.onExit(_owner);
				if (interruped)
				{
					_prevState.push(_localState);
				}
			}

			_localState = state;

			if (_localState)
			{
				_localState.onEnter(_owner);
			}
			
			return true;
		}
		
		public	function revertToPrevState():Boolean
		{
			if (_prevState.length == 0)
				return false;
			
			var prevState:IBzState = _prevState.pop();
			if (changeState(prevState))
			{
				return true;
			}
			else
			{
				_prevState.push(prevState);
				return false;
			}
		}
		
		public	function update():void
		{
			if (_localState)
				_localState.onPreExcute(_owner);
			if (_globalState)
				_globalState.onPreExcute(_owner);

			if (_globalState)
				_globalState.onPostExcute(_owner);
			if (_localState)
				_localState.onPostExcute(_owner);
		}
		
		public	function handleMessage(message:IBzMessage):void
		{
			if (_localState)
				_localState.onMessage(_owner, message);
			if (_globalState)
				_globalState.onMessage(_owner, message);
		}
	}
}