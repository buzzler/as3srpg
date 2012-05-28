package datas.objects.player
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	public class Standup implements IBzState
	{
		private	static var _instance:Standup;
		public	static function getInstance():Standup
		{
			if (_instance == null)
				_instance = new Standup();
			return _instance;
		}
		
		private	const MAX:int = 15;
		private	var _time:int = 0;
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.STANDUP);
			
			_time = 0;
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			
			_time++;
			if (_time >= MAX)
			{
				thinker.getFSM().changeState(Stand.getInstance());
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