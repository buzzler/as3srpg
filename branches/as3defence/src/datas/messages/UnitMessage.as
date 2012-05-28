package datas.messages
{
	import buzzler.system.ai.IBzMessage;
	import buzzler.system.ai.BzStateMachine;
	
	public class UnitMessage implements IBzMessage
	{
		private	static var _count:int = 0;
		
		public	static const WALK		:String = "WALK";
		public	static const WALK_ACK	:String = "WALK_ACK";
		public	static const ATTACK		:String = "ATTACK";
		public	static const ATTACK_ACK	:String = "ATTACK_ACK";
		
		private	var _id			:String;
		private	var _sender		:BzStateMachine;
		private	var _receiver	:BzStateMachine;
		private	var _message	:String;
		private	var _data		:Object;
		
		public function UnitMessage(sender:BzStateMachine, receiver:BzStateMachine, message:String, data:Object)
		{
			_id			= (++_count).toString();
			_sender		= sender;
			_receiver	= receiver;
			_message	= message;
			_data		= data;
		}
		
		public function getId():String
		{
			return _id;
		}
		
		public function getSender():BzStateMachine
		{
			return _sender;
		}
		
		public function getReceiver():BzStateMachine
		{
			return _receiver;
		}
		
		public function getMessage():String
		{
			return _message;
		}
		
		public function getData():Object
		{
			return _data;
		}
	}
}