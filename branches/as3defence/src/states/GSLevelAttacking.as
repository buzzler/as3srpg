package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Skill;
	import datas.messages.UnitMessage;
	import datas.objects.UnitBase;
	
	import mx.events.FlexEvent;
	
	public class GSLevelAttacking implements IBzState
	{
		public	static const NAME:String = "LEVEL_ATTACKING";
		
		private	var _game		:as3defence;
		private	var _offencer	:UnitBase;
		private	var _defencer	:UnitBase;
		private	var _skill		:Skill;
		
		public function GSLevelAttacking(offencer:UnitBase, defencer:UnitBase, skill:Skill)
		{
			_offencer	= offencer;
			_defencer	= defencer;
			_skill		= skill;
		}
		
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
			
			_offencer.getFSM().handleMessage( new UnitMessage(_game.getFSM(), _offencer.getFSM(), UnitMessage.ATTACK, [_defencer, _skill]) );
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
			var dcenter:DataCenter = DataCenter.getInstance();
			
			switch (message.getMessage())
			{
				case UnitMessage.ATTACK_ACK:
					if (dcenter.level.offencer.contain(_offencer))
					{
						dcenter.level.offencer.attackUnit(_offencer);
					}
					else if (dcenter.level.defencer.contain(_offencer))
					{
						dcenter.level.defencer.attackUnit(_offencer);
					}
					_game.getFSM().changeState( new GSLevelUnit(_offencer) );
					break;
			}
		}
	}
}