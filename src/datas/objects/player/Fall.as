package datas.objects.player
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzThinker;
	import buzzler.system.BzElementDetector;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import flash.geom.Vector3D;
	
	public class Fall implements IBzState
	{
		private	static var _instance:Fall;
		public	static function getInstance():Fall
		{
			if (_instance == null)
				_instance = new Fall();
			return _instance;
		}
		
		private	static const MOVE_SPEED	:Number = 0.08;
		private	static const GRAVITY_ACC:Number =-0.01;
		private	static const GRAVITY_MAX:Number =-0.23;		
		
		private	var _velocity:Number;
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.FALL);
			
			_velocity = 0;
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
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			var dcenter:DataCenter = DataCenter.getInstance();
			
			_velocity = Math.max(GRAVITY_MAX, _velocity+GRAVITY_ACC);
			
			var rect	:BzRectangle= thinker.getBzRectangle();
			var dir		:Vector3D	= new Vector3D();
			var dir_rot	:Number		= -1;
			
			if (dcenter.key_left)
			{
				dir_rot = dcenter.level.camera.unprojectRotation(BzRotation.WEST);
				thinker.setRotation(dir_rot);
			}
			else if (dcenter.key_right)
			{
				dir_rot = dcenter.level.camera.unprojectRotation(BzRotation.EAST);
				thinker.setRotation(dir_rot);
			}
			else if (dcenter.key_up)
			{
				dir_rot = dcenter.level.camera.unprojectRotation(BzRotation.NORTH);
				thinker.setRotation(dir_rot);
			}
			else if (dcenter.key_down)
			{
				dir_rot = dcenter.level.camera.unprojectRotation(BzRotation.SOUTH);
				thinker.setRotation(dir_rot);
			}
			
			switch (dir_rot)
			{
				case BzRotation.NORTH:
					if (isThroughable(rect.left, rect.top-MOVE_SPEED, rect.floor, rect.width, 0, rect.depth))
						dir.y = -MOVE_SPEED;
					else
						dir.y = Math.ceil(rect.top-MOVE_SPEED)-rect.top;
					break;
				case BzRotation.EAST:
					if (isThroughable(rect.right+MOVE_SPEED, rect.top, rect.floor, 0, rect.height, rect.depth))
						dir.x = MOVE_SPEED;
					else
						dir.x = Math.floor(rect.right+MOVE_SPEED)-rect.right;
					break;
				case BzRotation.SOUTH:
					if (isThroughable(rect.left, rect.bottom+MOVE_SPEED, rect.floor, rect.width, 0, rect.depth))
						dir.y = MOVE_SPEED;
					else
						dir.y = Math.floor(rect.bottom+MOVE_SPEED)-rect.bottom;
					break;
				case BzRotation.WEST:
					if (isThroughable(rect.left-MOVE_SPEED, rect.top, rect.floor, 0, rect.height, rect.depth))
						dir.x = -MOVE_SPEED;
					else
						dir.x = Math.ceil(rect.left-MOVE_SPEED)-rect.left;
					break;
			}
			
			if (isThroughable(rect.left,rect.top,rect.floor+_velocity,rect.width,rect.height,0))
			{
				dir.z = _velocity;
			}
			else
			{
				dir.z = Math.ceil(rect.floor+_velocity)-rect.floor;

				if (_velocity > GRAVITY_MAX)
					thinker.getFSM().changeState(Stand.getInstance());
				else
					thinker.getFSM().changeState(Crouch.getInstance());
			}
			
			thinker.addPosition(dir.x, dir.y, dir.z);
		}
		
		public function onPostExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
		}
		
		public function onExit(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
			var thinker:BzThinker = entity as BzThinker;
		}
	}
}