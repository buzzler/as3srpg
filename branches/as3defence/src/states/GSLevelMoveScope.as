package states
{
	import buzzler.core.BzScene;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzVoxel;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	import controller.InputListener;
	
	import datas.objects.Area;
	import datas.objects.BzBox;
	import datas.objects.BzDummy;
	import datas.objects.BzRock;
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	
	public class GSLevelMoveScope implements IBzState
	{
		public	static const NAME:String = "LEVEL_MOVESCOPE";
		private	var _game:as3defence;
		private	var _unit:UnitBase;
		private	var _greens:Vector.<Area>;
		
		public function GSLevelMoveScope(unit:UnitBase)
		{
			_unit = unit;
			_greens = new Vector.<Area>();
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
			_game.movescope_btn_cancel.addEventListener(MouseEvent.CLICK, onClickCancel);
			InputListener.getInstance().startKeyListening(_game.stage);
		
			var dcenter:DataCenter = DataCenter.getInstance();
			var positions:Vector.<BzVoxel> = _unit.getMovablePositions();
			for each(var voxel:BzVoxel in positions)
			{
				var vector:Vector3D = voxel.getPosition();
				var area:Area = new Area('AREA',vector.x,vector.y,vector.z,0x00FF00);
				dcenter.level.scene.addBzElement( area );
				_greens.push( area );
			}
		}
		
		private	function onClickCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelUnit(_unit) );
		}
		
		public function onPreExcute(entity:Object):void
		{
			var scene:BzScene = DataCenter.getInstance().level.scene;
			scene.update();
			scene.render();
			
			for each (var area:Area in _greens)
			{
				if (area.getTouchFlag())
				{
					area.clearTouchFlag();
					_game.getFSM().changeState( new GSLevelMoving( _unit, area.getPosition() ) );
					return;
				}
				area.clearTouchFlag();
			}
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			InputListener.getInstance().stopKeyListening();
			_game.movescope_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickCancel);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			for each (var area:Area in _greens)
			{
				area.clearTouchFlag();
				dcenter.level.scene.removeBzElement( area );
			}
			_greens.length = 0;
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}