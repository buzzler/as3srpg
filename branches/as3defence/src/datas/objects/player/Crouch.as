package datas.objects.player
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	public class Crouch implements IBzState
	{
		private	static var _instance:Crouch;
		public	static function getInstance():Crouch
		{
			if (_instance == null)
				_instance = new Crouch();
			return _instance;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.CROUCH);
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			var dcenter:DataCenter = DataCenter.getInstance();
			
			if (!dcenter.key_crouch)
			{
				thinker.getFSM().changeState(Standup.getInstance(), false);
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