package states
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Profile;
	
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	public class GSTitle implements IBzState
	{
		public	static const NAME:String = "TITLE";
		private	var _game:as3defence;
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			if (_game.currentState!=NAME)
			{
				_game.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
				_game.currentState = NAME;
			}
			else
			{
				onStateChange(null);
			}
		}
		
		private	function onStateChange(event:FlexEvent):void
		{
			_game.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onStateChange);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			var element:ProfileCard = new ProfileCard();
			
			element.setProfile( dcenter.viewer, onClickStart );
			_game.title_vgroup_viewer.addElement( element );
			for each (var friend:Profile in dcenter.profiles)
			{
				element = new ProfileCard();
				element.setProfile( friend, onClickStart );
				_game.title_hgourp_friends.addElement( element );
			}
		}

		private	function onClickStart( profile:Profile ):void
		{
			_game.getFSM().changeState( new GSLoadLevel( profile ) );
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