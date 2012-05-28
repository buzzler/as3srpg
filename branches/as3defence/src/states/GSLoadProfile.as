package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Collection;
	import datas.Item;
	import datas.Paths;
	import datas.Profile;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class GSLoadProfile implements IBzState
	{
		public	static const NAME:String = "LOAD_PROFILE";
		private	var _complete:Boolean;
		
		public function GSLoadProfile()
		{
			_complete = false;
		}
		
		public function onEnter(entity:Object):void
		{
			var game:as3defence = entity as as3defence;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadCompleteProfiles);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest( Paths.PROFILES ));

			game.currentState = NAME;
		}

		private	function onLoadCompleteProfiles(event:Event):void
		{
			var loader:URLLoader	= event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadCompleteProfiles);
			
			var dcenter:DataCenter	= DataCenter.getInstance();
			dcenter.xmlProfile		= XML(loader.data);
			dcenter.viewer			= Profile.generateFromXML( dcenter.xmlProfile.VIEWER[0] as XML );
			dcenter.profiles		= new Vector.<Profile>();
			for each (var xml:XML in dcenter.xmlProfile.PROFILE)
			{
				dcenter.profiles.push( Profile.generateFromXML(xml) );
			}
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadCompleteItemCollection);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest( Paths.ITEMS ));
		}
		
		private	function onLoadCompleteItemCollection(event:Event):void
		{
			var loader:URLLoader	= event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadCompleteItemCollection);
			
			var dcenter:DataCenter	= DataCenter.getInstance();
			dcenter.xmlItems		= XML(loader.data);
			dcenter.collection		= Collection.generateFromXMLList( dcenter.xmlItems.ITEM, Item.generateFromXML );

			_complete = true;
		}
		
		public function onPreExcute(entity:Object):void
		{
		}
		
		public function onPostExcute(entity:Object):void
		{
			var game:as3defence = entity as as3defence;
			if (_complete)
			{
				_complete = false;
				game.getFSM().changeState( new GSTitle() );
			}
		}
		
		public function onExit(entity:Object):void
		{
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}