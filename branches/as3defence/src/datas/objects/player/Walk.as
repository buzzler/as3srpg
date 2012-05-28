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
	
	import flashx.textLayout.elements.BreakElement;
	
	public class Walk implements IBzState
	{
		private	static var _instance:Walk;
		public	static function getInstance():Walk
		{
			if (_instance==null)
				_instance = new Walk();
			return _instance;
		}
		
		private	static const SPEED		:Number		= 0.08;
		private	static const GRAVITY_ACC:Number		=-0.01;
		private	static const V_NORTH	:Vector3D	= new Vector3D(0,-SPEED,0);
		private	static const V_SOUTH	:Vector3D	= new Vector3D(0, SPEED,0);
		private	static const V_EAST		:Vector3D	= new Vector3D( SPEED,0,0);
		private	static const V_WEST		:Vector3D	= new Vector3D(-SPEED,0,0);
		
		private	var _readyJump:Boolean;
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.WALK);
			_readyJump = !DataCenter.getInstance().key_space;
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
			
			var dir_rot:Number = -1;
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
			
			var rect:BzRectangle = thinker.getBzRectangle();
			var dir:Vector3D;
			switch (dir_rot)
			{
			case BzRotation.NORTH:
				if (isThroughable(rect.left, rect.top-SPEED, rect.floor, rect.width, 0, rect.depth))
					dir = V_NORTH;
				else
					dir = new Vector3D(0, Math.ceil(rect.top-SPEED)-rect.top, 0);
				break;
			case BzRotation.EAST:
				if (isThroughable(rect.right+SPEED, rect.top, rect.floor, 0, rect.height, rect.depth))
					dir = V_EAST;
				else
					dir = new Vector3D(Math.floor(rect.right+SPEED)-rect.right, 0, 0);
				break;
			case BzRotation.SOUTH:
				if (isThroughable(rect.left, rect.bottom+SPEED, rect.floor, rect.width, 0, rect.depth))
					dir = V_SOUTH;
				else
					dir = new Vector3D(0, Math.floor(rect.bottom+SPEED)-rect.bottom, 0);
				break;
			case BzRotation.WEST:
				if (isThroughable(rect.left-SPEED, rect.top, rect.floor, 0, rect.height, rect.depth))
					dir = V_WEST;
				else
					dir = new Vector3D(Math.ceil(rect.left-SPEED)-rect.left, 0, 0);
				break;
			}
			
			if (isThroughable(rect.left,rect.top,rect.floor+GRAVITY_ACC,rect.width,rect.height,0))
			{
				thinker.getFSM().changeState(Fall.getInstance());
			}
			else if (dcenter.key_space && _readyJump)
			{
				thinker.getFSM().changeState(Jump.getInstance());
			}
			else if (dcenter.key_grab)
			{
				thinker.getFSM().changeState(Grab.getInstance());
			}
			else if (dcenter.key_crouch)
			{
				thinker.getFSM().changeState(Crouch.getInstance());
			}
			else if (dir == null)
			{
				thinker.getFSM().changeState(Stand.getInstance());
			}
			else if (dir.lengthSquared > 0.001)
			{
				thinker.addPosition(dir.x, dir.y, dir.z);
			}
			
			if (!dcenter.key_space && !_readyJump)
			{
				_readyJump = true;
			}
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