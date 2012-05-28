package datas.objects.player
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	public class Pull implements IBzState
	{
		private	static var _instance:Pull;
		public	static function getInstance():Pull
		{
			if (_instance == null)
				_instance = new Pull();
			return _instance;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.PULL);
		}
		
		public function onPreExcute(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
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