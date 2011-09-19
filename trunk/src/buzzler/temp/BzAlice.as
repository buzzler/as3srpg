package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzAlice extends BzElement
	{
		[Embed(source="../assets/sprite/32x64_idle_north.png")]
		private	static var _Idle_N	:Class;
		[Embed(source="../assets/sprite/32x64_idle_east.png")]
		private	static var _Idle_E	:Class;
		[Embed(source="../assets/sprite/32x64_idle_south.png")]
		private	static var _Idle_S	:Class;
		[Embed(source="../assets/sprite/32x64_idle_west.png")]
		private	static var _Idle_W	:Class;
		[Embed(source="../assets/sprite/32x64_walk_north.png")]
		private	static var _Walk_N	:Class;
		[Embed(source="../assets/sprite/32x64_walk_east.png")]
		private	static var _Walk_E	:Class;
		[Embed(source="../assets/sprite/32x64_walk_south.png")]
		private	static var _Walk_S	:Class;
		[Embed(source="../assets/sprite/32x64_walk_west.png")]
		private	static var _Walk_W	:Class;
		private	static var _idle_n	:BzSprite	= new BzSprite(new _Idle_N().bitmapData, 32, 64,-16,0, 0.1, true);
		private	static var _idle_e	:BzSprite	= new BzSprite(new _Idle_E().bitmapData, 32, 64,-16,0, 0.1, true);
		private	static var _idle_s	:BzSprite	= new BzSprite(new _Idle_S().bitmapData, 32, 64,-16,0, 0.1, true);
		private	static var _idle_w	:BzSprite	= new BzSprite(new _Idle_W().bitmapData, 32, 64,-16,0, 0.1, true);
		private	static var _walk_n	:BzSprite	= new BzSprite(new _Walk_N().bitmapData, 32, 64,-16,0, 0.2, false);
		private	static var _walk_e	:BzSprite	= new BzSprite(new _Walk_E().bitmapData, 32, 64,-16,0, 0.2, false);
		private	static var _walk_s	:BzSprite	= new BzSprite(new _Walk_S().bitmapData, 32, 64,-16,0, 0.2, false);
		private	static var _walk_w	:BzSprite	= new BzSprite(new _Walk_W().bitmapData, 32, 64,-16,0, 0.2, false);
		
		public function BzAlice(x:int, y:int, z:int)
		{
			var state_idle:BzState = new BzState(BzStateType.IDLE, _idle_n, _idle_e, _idle_s, _idle_w);
			var state_walk:BzState = new BzState(BzStateType.WALK, _walk_n, _walk_e, _walk_s, _walk_w);
			var sets:BzSet = new BzSet("ALICE");
			sets.addState(state_idle);
			sets.addState(state_walk);
			
			super(sets, BzStateType.WALK, new BzRectangle(x,y,z));
		}
	}
}