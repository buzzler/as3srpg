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
	
	public class GSLevelUnit implements IBzState
	{
		public	static const NAME:String = "LEVEL_UNIT";
		private	var _game:as3defence;
		private	var _unit:UnitBase;
		
		public function GSLevelUnit(unit:UnitBase):void
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
			
			var dcenter:DataCenter	= DataCenter.getInstance();
			var movable:Boolean		= dcenter.level.offencer.isMovable(_unit);
			var attackable:Boolean	= dcenter.level.offencer.isAttackable(_unit);
			
			if (movable==false && attackable==false)
			{
				_game.getFSM().changeState( new GSLevelReady() );
				return;
			}
			if (movable)
			{
				_game.unit_btn_move.enabled = true;
				_game.unit_btn_move.addEventListener(MouseEvent.CLICK, onClickUnitMove);
			}
			else
			{
				_game.unit_btn_move.enabled = false;
			}
			if (attackable)
			{
				_game.unit_btn_action.enabled = true;
				_game.unit_btn_item.enabled = true;
				_game.unit_btn_action.addEventListener(MouseEvent.CLICK, onClickUnitAction);
				_game.unit_btn_item.addEventListener(MouseEvent.CLICK, onClickUnitItem);
			}
			else
			{
				_game.unit_btn_action.enabled = false;
				_game.unit_btn_item.enabled = false;
			}
			_game.unit_btn_cancel.addEventListener(MouseEvent.CLICK, onClickUnitCancel);
			InputListener.getInstance().startKeyListening(_game.stage);
		}
		
		private	function onClickUnitAction(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelAction(_unit) );
		}
		
		private	function onClickUnitMove(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelMoveScope(_unit) );
		}
		
		private	function onClickUnitItem(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelInventory(_unit) );
		}
		
		private	function onClickUnitCancel(event:MouseEvent):void
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
			_game.unit_btn_action.removeEventListener(MouseEvent.CLICK, onClickUnitAction);
			_game.unit_btn_move.removeEventListener(MouseEvent.CLICK, onClickUnitMove);
			_game.unit_btn_item.removeEventListener(MouseEvent.CLICK, onClickUnitItem);
			_game.unit_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickUnitCancel);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}