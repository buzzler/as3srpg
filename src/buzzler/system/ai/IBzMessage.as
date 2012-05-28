package buzzler.system.ai
{
	public interface IBzMessage
	{
		function getId()		:String;
		function getSender()	:BzStateMachine;
		function getReceiver()	:BzStateMachine;
		function getMessage()	:String;
		function getData()		:Object;
	}
}