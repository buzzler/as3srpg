package datas.objects.units
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRotation;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.BzStateMachine;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.messages.UnitMessage;
	
	import flash.geom.Vector3D;
	
	public class Walk implements IBzState
	{
		private	const _SPEED:Number = 0.08;
		
		private	var _commander	:BzStateMachine;
		private	var _path		:Vector.<BzVoxel>;
		private	var _target		:int;
		
		public	function Walk(data:Object, commander:BzStateMachine = null):void
		{
			_commander	= commander;
			_path		= data as Vector.<BzVoxel>;
			_target		= 0;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.WALK);
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			var target:Vector3D = _path[_target].getPosition();
			var normal:Vector3D = target.subtract( thinker.getPosition() );
			if (normal.length > 1)
			{
				if (thinker.getPosition().z < target.z)
				{
					thinker.getFSM().changeState( new JumpBig(_path.splice(_target,_path.length-_target), _commander) );
				}
				else
				{
					thinker.getFSM().changeState( new JumpSmall(_path.splice(_target,_path.length-_target), _commander) );
				}
				return;
			}
			var distance:Number = Math.min( normal.normalize(), _SPEED );
			
			if (normal.x < 0)
			{
				thinker.setRotation(BzRotation.WEST);
			}
			else if (normal.x > 0)
			{
				thinker.setRotation(BzRotation.EAST);
			}
			else if (normal.y < 0)
			{
				thinker.setRotation(BzRotation.NORTH);
			}
			else if (normal.y > 0)
			{
				thinker.setRotation(BzRotation.SOUTH);
			}
			
			if (distance > 0.01)
			{
				thinker.addPosition( normal.x*distance , normal.y*distance , normal.z*distance );
			}
			else
			{
				thinker.setPosition( target.x, target.y, target.z );
				if (++_target >= _path.length)
				{
					thinker.getFSM().changeState( new Normal() );
					if (_commander)
					{
						_commander.handleMessage( new UnitMessage(thinker.getFSM(), _commander, UnitMessage.WALK_ACK, null) );
					}
				}
			}
		}
		
		public function onPostExcute(entity:Object):void
		{
		}
		
		public function onExit(entity:Object):void
		{
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}