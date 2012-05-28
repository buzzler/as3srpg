package states
{
	import buzzler.core.BzScene;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzElement;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	import controller.InputListener;
	
	import datas.Skill;
	import datas.objects.Area;
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	
	public class GSLevelAttackScope implements IBzState
	{
		public	static const NAME:String = "LEVEL_ATTACKSCOPE";
		
		private	var _game	:as3defence;
		private	var _unit	:UnitBase;
		private	var	_skill	:Skill;
		private	var _reds	:Vector.<Area>;
		private	var _targets:Vector.<UnitBase>;
		
		public	function GSLevelAttackScope(unit:UnitBase, skill:Skill):void
		{
			_unit	= unit;
			_skill	= skill;
			_reds	= new Vector.<Area>();
			_targets= new Vector.<UnitBase>();
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
			_game.attackscope_btn_cancel.addEventListener(MouseEvent.CLICK, onClickCancel);
			InputListener.getInstance().startKeyListening(_game.stage);
			
			var dcenter:DataCenter			= DataCenter.getInstance();
			var positions:Vector.<BzVoxel>	= new Vector.<BzVoxel>();
			var enemies:Vector.<BzVoxel>	= new Vector.<BzVoxel>();
			_skill.getAvailableBzVoxels(_unit, positions, enemies);
			for each(var voxel:BzVoxel in positions)
			{
				var vector:Vector3D = voxel.getPosition();
				var area:Area = new Area('AREA',vector.x,vector.y,vector.z,0xFF0000);
				dcenter.level.scene.addBzElement( area );
				_reds.push( area );
			}
			
			for each (voxel in enemies)
			{
				var elements:Vector.<BzElement> = voxel.getBzElements();
				for each (var element:BzElement in elements)
				{
					if (element is UnitBase)
					{
						_targets.push(element as UnitBase);
					}
				}
			}
		}
		
		private	function onClickCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelAction(_unit) );
		}
		
		public function onPreExcute(entity:Object):void
		{
			var scene:BzScene = DataCenter.getInstance().level.scene;
			scene.update();
			scene.render();
			
			for each (var enemy:UnitBase in _targets)
			{
				if (enemy.getTouchFlag())
				{
					enemy.clearTouchFlag();
					_game.getFSM().changeState( new GSLevelAttacking( _unit, enemy, _skill ) );
					return;
				}
				enemy.clearTouchFlag();
			}
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
			InputListener.getInstance().stopKeyListening();
			_game.attackscope_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickCancel);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			for each (var area:Area in _reds)
			{
				area.clearTouchFlag();
				dcenter.level.scene.removeBzElement( area );
			}
			_reds.length = 0;
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}