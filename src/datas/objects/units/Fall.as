package datas.objects.units
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzThinker;
	import buzzler.system.BzElementDetector;
	import buzzler.system.ai.BzStateMachine;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.messages.UnitMessage;
	
	import flash.geom.Vector3D;
	
	public class Fall implements IBzState
	{
		private	static const _SPEED	:Number 	= 0.04;
		private	static const GRAVITY_ACC:Number =-0.01;
		private	static const GRAVITY_MAX:Number =-0.23;
		
		private	var _path		:Vector.<BzVoxel>;
		private	var _commander	:BzStateMachine;
		private	var _target		:int;
		
		private	var _velocity	:Number;
		
		public function Fall(path:Vector.<BzVoxel>, commander:BzStateMachine = null)
		{
			_commander	= commander;
			_path		= path;
			_target		= 0;
			_velocity	= 0;
		}
		
		private	function isThroughable(x:Number, y:Number, z:Number, w:int, h:int, d:int):Boolean
		{
			var dcenter:DataCenter		= DataCenter.getInstance();
			var voxel:BzElementDetector	= dcenter.level.scene.getBzElementDetector();
			
			w = (x%1 == 0) ? w-1:w;
			h = (y%1 == 0) ? h-1:h;
			d = (z%1 == 0) ? d-1:d;
			
			for (var i:int = 0 ; i <= w ; i++)
			{
				for (var j:int = 0 ; j <= h ; j++)
				{
					for (var k:int = 0 ; k <= d ; k++)
					{
						var v:BzVoxel = voxel.getBzVoxel(Math.floor(x+i),Math.floor(y+j),Math.floor(z+k));
						if ((v==null) || (!v.isThroughable()))
							return false;
					}
				}
			}
			return true;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.FALL);
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			var rect:BzRectangle = thinker.getBzRectangle();
			var target:Vector3D = _path[_target].getPosition();
			var normal:Vector3D = target.subtract( thinker.getPosition() );
			var distance:Number = Math.min( normal.normalize(), _SPEED );
			_velocity = Math.max(GRAVITY_MAX, _velocity+GRAVITY_ACC);
			
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
			
			if (distance <= 0.01)
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
			else if (target.z < rect.floor+_velocity)
			{
				thinker.addPosition( normal.x*distance , normal.y*distance , _velocity );
			}
			else
			{
				thinker.addPosition( normal.x*distance , normal.y*distance , normal.z*distance );
				thinker.getFSM().changeState( new Walk(_path.splice(_target,_path.length-_target), _commander) );
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