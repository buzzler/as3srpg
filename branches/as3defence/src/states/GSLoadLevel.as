package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Level;
	import datas.Paths;
	import datas.Profile;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class GSLoadLevel implements IBzState
	{
		public	static const NAME:String = "LOAD_LEVEL";
		private	var _game:as3defence;
		private	var _owner:Profile;
		
		public	function GSLoadLevel( owner:Profile ):void
		{
			_owner = owner;
		}
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			
			var dcenter:DataCenter = DataCenter.getInstance();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadCompleteLevel);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest( Paths.LEVEL + "?viewer=" + dcenter.viewer.id + "&owner=" + _owner.id));

			_game.currentState = NAME;
		}
		
		
		private	function onLoadCompleteLevel(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadCompleteLevel);
			
			var dcenter:DataCenter	= DataCenter.getInstance();
			dcenter.xmlLevel		= XML(loader.data);
			dcenter.level			= Level.generateFromXML( dcenter.xmlLevel );
			
			_game.getFSM().changeState( new GSLevelConstuctor() );
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