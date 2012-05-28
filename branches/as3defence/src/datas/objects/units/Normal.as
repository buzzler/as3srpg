package datas.objects.units
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.BzStateMachine;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Skill;
	import datas.messages.UnitMessage;
	
	public class Normal implements IBzState
	{
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType(BzSheetType.IDLE);
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
			var thinker:BzThinker = entity as BzThinker;
			
			switch (message.getMessage())
			{
			case UnitMessage.WALK:
				thinker.getFSM().changeState( new Walk(message.getData(), message.getSender()) );
				break;
			case UnitMessage.ATTACK:
				thinker.getFSM().changeState( new Attack(message.getData(), message.getSender()) );
				break;
			}
		}
	}
}