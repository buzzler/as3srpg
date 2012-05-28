package buzzler.system.ai
{
	public interface IBzState
	{
		function onEnter(entity:Object)							:void;
		function onPreExcute(entity:Object)						:void;
		function onPostExcute(entity:Object)					:void;
		function onExit(entity:Object)							:void;
		function onMessage(entity:Object, message:IBzMessage)	:void;
	}
}