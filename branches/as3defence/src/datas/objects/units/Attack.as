package datas.objects.units
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzDisplayObject;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.BzStateMachine;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import datas.Skill;
	import datas.messages.UnitMessage;
	import datas.objects.UnitBase;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class Attack implements IBzState
	{
		private	var _opponent	:UnitBase;
		private	var _skill		:Skill;
		private var _commander	:BzStateMachine;
		private	var _sheet		:BzSheet;
		
		public function Attack(data:Object, commander:BzStateMachine = null)
		{
			_opponent	= data[0] as UnitBase;
			_skill		= data[1] as Skill;
			_commander	= commander;
		}
		
		public function onEnter(entity:Object):void
		{
			var thinker:BzThinker = entity as BzThinker;
			thinker.setSheetType( _skill.motion );
			
			_sheet = thinker.getBzSheet();
		}
		
		public function onPreExcute(entity:Object):void
		{
			var unit:UnitBase = entity as UnitBase;
			var target:Vector3D = _opponent.getPosition();
			var normal:Vector3D = target.subtract( unit.getPosition() );
			if (normal.x < 0)
			{
				unit.setRotation(BzRotation.WEST);
			}
			else if (normal.x > 0)
			{
				unit.setRotation(BzRotation.EAST);
			}
			else if (normal.y < 0)
			{
				unit.setRotation(BzRotation.NORTH);
			}
			else if (normal.y > 0)
			{
				unit.setRotation(BzRotation.SOUTH);
			}
			
			var views:Dictionary = unit.getBzDisplayObjects();
			for each (var view:BzDisplayObject in views)
			{
				var sheet:BzSheet = view.getBzSheet();
				var sprite:BzSprite = view.getBzSprite();
				
				if (sheet != _sheet)
				{
					continue;
				}
				if (!sprite.containReferer(view))
				{
					continue;
				}

				if (sprite.getCurrentFrame(view) >= (sprite.getTotalFrame()-1) )
				{
					unit.giveAffection(_skill, _opponent);
					_opponent.takeAffection(_skill, unit);
					
					unit.getFSM().changeState( new Normal() );
					if (_commander)
					{
						_commander.handleMessage( new UnitMessage(unit.getFSM(), _commander, UnitMessage.ATTACK_ACK, null) );
					}
				}
			}
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