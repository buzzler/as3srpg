package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelTake implements IBzState
	{
		public	static const NAME:String = "LEVEL_TAKE";
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
			_game.take_btn_ok.addEventListener(MouseEvent.CLICK, onClickTakeSkip);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			dcenter.level.defencer.reset();
		}
		
		private	function onClickTakeSkip(event:MouseEvent):void
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
			_game.take_btn_ok.removeEventListener(MouseEvent.CLICK, onClickTakeSkip);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}