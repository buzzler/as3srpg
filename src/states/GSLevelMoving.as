package states
{
	import buzzler.core.BzScene;
	import buzzler.data.BzVoxel;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.messages.UnitMessage;
	import datas.objects.UnitBase;
	import datas.objects.units.Normal;
	
	import flash.geom.Vector3D;
	
	import flashx.textLayout.elements.BreakElement;
	
	import luaAlchemy.LuaAlchemy;
	
	import mx.events.FlexEvent;
	
	public class GSLevelMoving implements IBzState
	{
		public	static const NAME:String = "LEVEL_MOVING";
		private	var _game		:as3defence;
		private	var _unit		:UnitBase;
		private	var _destination:Vector3D;
		
		public function GSLevelMoving( unit:UnitBase, destination:Vector3D )
		{
			_unit		= unit;
			_destination= destination;
		}
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			if (_game.currentState!=NAME)
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
			
			var dcenter:DataCenter = DataCenter.getInstance();
			var path:Vector.<BzVoxel> = dcenter.level.scene.getBzElementDetector().getPath(_unit.getPosition(), _destination, compFunc);
			
			_unit.getFSM().handleMessage( new UnitMessage(_game.getFSM(), _unit.getFSM(), UnitMessage.WALK, path) );
		}
		
		private	function compFunc(cell:BzVoxel):Boolean
		{
			return cell.isWalkable();
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
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
			var dcenter:DataCenter = DataCenter.getInstance();
			
			switch (message.getMessage())
			{
			case UnitMessage.WALK_ACK:
				if (dcenter.level.offencer.contain(_unit))
				{
					dcenter.level.offencer.moveUnit(_unit);
				}
				else if (dcenter.level.defencer.contain(_unit))
				{
					dcenter.level.defencer.moveUnit(_unit);
				}
				_game.getFSM().changeState( new GSLevelUnit(_unit) );
				break;
			}
		}
	}
}