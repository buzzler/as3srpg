package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	import controller.DragListener;
	import controller.InputListener;
	
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class GSLevelReady implements IBzState
	{
		public	static const NAME:String = "LEVEL_READY";
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
			_game.ready_btn_system.addEventListener(MouseEvent.CLICK, onClickSystemMenu);
			InputListener.getInstance().startKeyListening(_game.stage);
			DragListener.getInstance().startDragListening(DataCenter.getInstance().level.viewport);
		}
		
		private	function onClickSystemMenu(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelSystem() );
		}
		
		public function onPreExcute(entity:Object):void
		{
			var dcenter:DataCenter = DataCenter.getInstance();
			dcenter.level.scene.update();
			dcenter.level.scene.render();
			
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
			DragListener.getInstance().stopDragListening();
			InputListener.getInstance().stopKeyListening();
			_game.ready_btn_system.removeEventListener(MouseEvent.CLICK, onClickSystemMenu);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}