package datas.objects.box
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	public class Ready implements IBzState
	{
		private	static var _instance:Ready;
		public	static function getInstance():Ready
		{
			if (_instance==null)
				_instance = new Ready();
			return _instance;
		}
		
		public function Ready()
		{
		}
		
		public function onEnter(entity:Object):void
		{
		}
		
		public function onPreExcute(entity:Object):void
		{
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