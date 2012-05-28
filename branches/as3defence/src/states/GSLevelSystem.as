package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	
	public class GSLevelSystem implements IBzState
	{
		public	static const NAME:String = "LEVEL_SYSTEM";
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
			_game.system_btn_turn.addEventListener(MouseEvent.CLICK, onClickSystemTurn);
			_game.system_btn_cancel.addEventListener(MouseEvent.CLICK, onClickSystemCancel);
		}
		
		private	function onClickSystemTurn(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelLose() );
		}
		
		private	function onClickSystemCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelReady() );
		}
		
		public function onPreExcute(entity:Object):void
		{
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			_game.system_btn_turn.removeEventListener(MouseEvent.CLICK, onClickSystemTurn);
			_game.system_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickSystemCancel);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}