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
	
	public class JumpBig implements IBzState
	{
		private	static const _SPEED				:Number = 0.04;
		private	static const HEIGHT_MAX			:Number = 1.4;
		private	static const HEIGHT_SPEED_MAX	:Number	= Math.PI/2;
		private	static const HEIGHT_SPEED_MIN	:Number	= 0;
		private	static const HEIGHT_SPEED		:Number = HEIGHT_SPEED_MAX/10;
		
		private	var _commander:BzStateMachine;
		private	var _path:Vector.<BzVoxel>;
		private	var _target:int;
		
		private	var _time	:Number;
		private	var _theta	:Number;
		
		public function JumpBig(path:Vector.<BzVoxel>, commander:BzStateMachine = null)
		{
			_commander	= commander;
			_path		= path;
			_target		= 0;

			_time		= HEIGHT_SPEED_MIN;
			_theta		= 0;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.JUMP);
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			
			if (_time > HEIGHT_SPEED_MAX)
			{
				thinker.getFSM().changeState( new Fall(_path.splice(_target,_path.length-_target), _commander) );
				return;
			}
			else
			{
				_time += HEIGHT_SPEED;
				
				var target:Vector3D = _path[_target].getPosition();
				var normal:Vector3D = target.subtract( thinker.getPosition() );
				var distance:Number = Math.min( normal.normalize(), _SPEED );
				var theta	:Number	= Math.sin(_time) * HEIGHT_MAX;
				
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
					thinker.addPosition( normal.x*distance , normal.y*distance , theta-_theta );
					_theta = theta;
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