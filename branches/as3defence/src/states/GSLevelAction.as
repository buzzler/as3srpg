package states
{
	import buzzler.core.BzScene;
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.IBzState;
	
	import controller.DataCenter;
	
	import datas.Skill;
	import datas.objects.UnitBase;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.events.IndexChangeEvent;
	
	public class GSLevelAction implements IBzState
	{
		public	static const NAME:String = "LEVEL_ACTION";
		private	var _game:as3defence;
		private	var _unit:UnitBase;
		
		public	function GSLevelAction(unit:UnitBase):void
		{
			_unit = unit;
		}
		
		public function onEnter(entity:Object):void
		{
			_game = entity as as3defence;
			if (_game.currentState != NAME)
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
			_game.action_btn_block.addEventListener(MouseEvent.CLICK, onClickActionBlock);
			_game.action_btn_rest.addEventListener(MouseEvent.CLICK, onClickActionRest);
			_game.action_btn_cancel.addEventListener(MouseEvent.CLICK, onClickActionCancel);
			_game.action_list_skill.addEventListener(IndexChangeEvent.CHANGE, onClickSkill);

			var source:Array = new Array();
			for each (var skill:Skill in _unit.skill.getHashMap())
			{
				source.push( skill );
			}
			source.sortOn("name");
			_game.action_list_skill.dataProvider = new ArrayCollection(source);
			_game.action_list_skill.labelFunction = function (item:Skill):String
			{
				return item.name + " : " + item.description;
			};
		}

		private	function onClickActionBlock(event:MouseEvent):void
		{
			// do something
			
			_game.getFSM().changeState( new GSLevelReady() );
		}
		
		private	function onClickActionRest(event:MouseEvent):void
		{
			// do something
			
			_game.getFSM().changeState( new GSLevelReady() );
		}
		
		private	function onClickSkill(event:IndexChangeEvent):void
		{
			_game.getFSM().changeState( new GSLevelAttackScope(_unit, _game.action_list_skill.selectedItem as Skill) );
		}
		
		private	function onClickActionCancel(event:MouseEvent):void
		{
			_game.getFSM().changeState( new GSLevelUnit(_unit) );
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
			_game.action_btn_block.removeEventListener(MouseEvent.CLICK, onClickActionBlock);
			_game.action_btn_rest.removeEventListener(MouseEvent.CLICK, onClickActionRest);
			_game.action_btn_cancel.removeEventListener(MouseEvent.CLICK, onClickActionCancel);
			_game.action_list_skill.removeEventListener(IndexChangeEvent.CHANGE, onClickSkill);
		}
		
		public function onMessage(entity:Object, message:IBzMessage):void
		{
		}
	}
}