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
	
	public class Jump implements IBzState
	{
		private	static var _instance:Jump;
		public	static function getInstance():Jump
		{
			if (_instance == null)
				_instance = new Jump();
			return _instance;
		}
		
		private	static const MOVE_SPEED			:Number = 0.08;
		private	static const HEIGHT_MAX			:Number = 1.4;
		private	static const HEIGHT_SPEED_MAX	:Number	= Math.PI/2;
		private	static const HEIGHT_SPEED_MIN	:Number	= 0;
		private	static const HEIGHT_SPEED		:Number = HEIGHT_SPEED_MAX/10;
		
		private	var _time	:Number;
		private	var _theta	:Number;
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.JUMP);
			
			_time = HEIGHT_SPEED_MIN;
			_theta = 0;
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
			
			if (dcenter.key_space)
			{
				if (_time > HEIGHT_SPEED_MAX)
				{
					thinker.getFSM().changeState(Fall.getInstance());
				}
				else
				{
					_time += HEIGHT_SPEED;
					
					var rect	:BzRectangle= thinker.getBzRectangle();
					var dir		:Vector3D	= new Vector3D();
					var dir_rot	:Number		= -1;
					var theta	:Number		= Math.sin(_time) * HEIGHT_MAX;
					
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

					var diff:Number = theta - _theta;
					if (isThroughable(rect.left,rect.top,rect.ceil+diff,rect.width,rect.height,0))
						dir.z = diff;
					else
						dir.z = Math.floor(rect.ceil+diff)-rect.ceil;

					_theta = theta;
					thinker.addPosition(dir.x, dir.y, dir.z);
				}
			}
			else
			{
				thinker.getFSM().changeState(Fall.getInstance());
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