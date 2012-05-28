package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelCondition implements IBzState
	{
		public	static const NAME:String = "LEVEL_CONDITION";
		private	var _game:as3defence;
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			if (_game.currentState != NAME)
			{
				_game.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
				_game.currentState = "LEVEL_CONDITION";
			}
			else
			{
				onStateChange(null);
			}
		}
		
		private	function onStateChange(event:FlexEvent):void
		{
			_game.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
			_game.condition_btn_ok.addEventListener(MouseEvent.CLICK, onClickConditionOk);
		}
		
		private	function onClickConditionOk(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelTake() );
		}
		
		public function onPreExcute(entity:Object):void
		{
			var scene:BzScene = DataCenter.getInstance().level.scene;
			scene.update();
			scene.render();
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			_game.condition_btn_ok.removeEventListener(MouseEvent.CLICK, onClickConditionOk);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}