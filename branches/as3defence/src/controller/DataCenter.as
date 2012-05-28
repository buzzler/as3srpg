package controller
{
	import datas.Collection;
	import datas.Level;
	import datas.Profile;
	
	import flash.geom.Point;

	public class DataCenter
	{
		private	static var _instance:DataCenter;
		public	static function getInstance():DataCenter
		{
			if (_instance == null)
				_instance = new DataCenter();
			return _instance;
		}
		
		public	var xmlProfile	:XML;
		public	var xmlLevel	:XML;
		public	var xmlItems	:XML;
		
		public	var viewer		:Profile;
		public	var collection	:Collection;
		public	var profiles	:Vector.<Profile>;
		public	var level		:Level;
		
		public	var touch_drag	:Boolean;
		public	var touch_origin:Point;
		public	var touch_dist	:Point;
		
		public	var key_up		:Boolean;
		public	var key_down	:Boolean;
		public	var key_left	:Boolean;
		public	var key_right	:Boolean;
		public	var key_space	:Boolean;
		public	var key_crouch	:Boolean;
		public	var key_grab	:Boolean;
	}
}