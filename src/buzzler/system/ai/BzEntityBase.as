package buzzler.system.ai
{
	public class BzEntityBase
	{
		private	static var _hash:Object = {};
		public	static function getEntity(id:String):BzEntityBase
		{
			if (id)
			{
				return _hash[id] as BzEntityBase;
			}
			else
			{
				return null;
			}
		}
		
		protected	var _id	:String;
		protected	var _fsm:BzStateMachine;
		
		public	function BzEntityBase():void
		{
			_id		= null;
			_fsm	= new BzStateMachine(this);
		}
		
		public	function setId(id:String):void
		{
			if (_id)
			{
				delete _hash[_id];
			}
			
			_id = id;
			
			if (_id)
			{
				_hash[_id] = this;
			}
		}
		
		public	function getId():String
		{
			return _id;
		}
		
		public	function getFSM():BzStateMachine
		{
			return _fsm;
		}
	}
}