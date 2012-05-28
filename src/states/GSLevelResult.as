package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelResult implements IBzState
	{
		public	static const NAME:String = "LEVEL_RESULT";
		private	var _game:as3defence;
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			if (_game.currentState != NAME)
			{
				_game.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
				_game.currentState = NAME;
			}
			else
			{
				onStateChange(null);
			}
		}
		
		private	function onStateChange(event:FlexEvent):void
		{
			_game.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
			_game.ready_btn_system.addEventListener(MouseEvent.CLICK, onClickResultOk);
		}
		
		private	function onClickResultOk(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelDestructor() );
		}
		
		public function onPreExcute(entity:Object):void
		{
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			_game.ready_btn_system.removeEventListener(MouseEvent.CLICK, onClickResultOk);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}