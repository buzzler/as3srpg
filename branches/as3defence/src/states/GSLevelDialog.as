package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	public class GSLevelDialog implements IBzState
	{
		public	static const NAME:String = "LEVEL_DIALOG";
		
		public function GSLevelDialog()
		{
		}
		
		public function onEnter(entity:Object):void
		{
			var game:as3defence = entity as as3defence;
			game.currentState = NAME;
		}
		
		public function onPreExcute(entity:Object):void
		{
			var scene:BzScene = DataCenter.getInstance().level.scene;
			scene.update();
			scene.render();
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