package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelAI implements IBzState
	{
		public	static const NAME:String = "LEVEL_AI";
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
			_game.ai_btn_skip.addEventListener(MouseEvent.CLICK, onClickAISkip);
		}
		
		private	function onClickAISkip(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelTake() );
		}
		
		public function onPreExcute(entity:Object):void
		{
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			_game.ai_btn_skip.removeEventListener(MouseEvent.CLICK, onClickAISkip);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}