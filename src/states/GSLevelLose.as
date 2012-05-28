package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import controller.DataCenter;
	
	public class GSLevelLose implements IBzState
	{
		public	static const NAME:String = "LEVEL_LOSE";
		private var _game:as3defence;
		
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
			_game.lose_btn_ok.addEventListener(MouseEvent.CLICK, onClickLoseSkip);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			dcenter.level.offencer.reset();
		}
		
		private	function onClickLoseSkip(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelAI() );
		}
		
		public function onPreExcute(entity:Object):void
		{
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			_game.lose_btn_ok.removeEventListener(MouseEvent.CLICK, onClickLoseSkip);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}