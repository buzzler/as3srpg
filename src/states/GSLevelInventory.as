package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelInventory implements IBzState
	{
		public	static const NAME:String = "LEVEL_INVEN";
		private	var _game:as3defence;
		private	var _unit:UnitBase;
		
		public function GSLevelInventory(unit:UnitBase):void
		{
			_unit = unit;
		}
		
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
			_game.inven_btn_cancel.addEventListener(MouseEvent.CLICK, onClickInvenCancel);
		}
		
		private	function onClickInvenCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelUnit(_unit) );
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
			_game.inven_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickInvenCancel);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}