package datas.objects.player
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRotation;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import flash.geom.Vector3D;
	
	public class Stand implements IBzState
	{
		private	static var _instance:Stand;
		public	static function getInstance():Stand
		{
			if (_instance==null)
				_instance = new Stand();
			return _instance;
		}
		
		private	var _readyJump:Boolean;
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.IDLE);
			
			_readyJump = !DataCenter.getInstance().key_space;
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			var dcenter:DataCenter = DataCenter.getInstance();

			if (dcenter.key_space && _readyJump)
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
			else if (dcenter.key_down||dcenter.key_left||dcenter.key_right||dcenter.key_up)
			{
				thinker.getFSM().changeState(Walk.getInstance());
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