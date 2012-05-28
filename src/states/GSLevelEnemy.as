package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	import controller.InputListener;
	
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelEnemy implements IBzState
	{
		public	static const NAME:String = "LEVEL_ENEMY";
		private	var _game:as3defence;
		private	var _unit:UnitBase;
		
		public function GSLevelEnemy(unit:UnitBase)
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
			_game.enemy_btn_cancel.addEventListener(MouseEvent.CLICK, onClickCancel);
			InputListener.getInstance().startKeyListening(_game.stage);
		}
		
		private	function onClickCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelReady() );
		}
		
		public function onPreExcute(entity:Object):void
		{
			var dcenter:DataCenter = DataCenter.getInstance();
			dcenter.level.scene.update();
			dcenter.level.scene.render();
			
			if (_unit.getTouchFlag())
			{
				dcenter.level.offencer.clearTouchFlag();
				dcenter.level.defencer.clearTouchFlag();
				_game.getFSM().changeState( new GSLevelReady() );
			}
			
			for each (var unit:UnitBase in dcenter.level.units.getHashMap())
			{
				if (!unit.getTouchFlag())
				{
					continue;
				}
				
				if (dcenter.level.offencer.contain(unit))
				{
					if ( dcenter.level.offencer.isMovable(unit) || dcenter.level.offencer.isAttackable(unit) )
					{
						dcenter.level.offencer.clearTouchFlag();
						dcenter.level.defencer.clearTouchFlag();
						_game.getFSM().changeState( new GSLevelUnit(unit) );
					}
				}
				else if (dcenter.level.defencer.contain(unit))
				{
					dcenter.level.offencer.clearTouchFlag();
					dcenter.level.defencer.clearTouchFlag();
					_game.getFSM().changeState( new GSLevelEnemy(unit) );
				}
				unit.clearTouchFlag();
			}
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			InputListener.getInstance().stopKeyListening();
			_game.enemy_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickCancel);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}