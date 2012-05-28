package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzThinker;
	import buzzler.system.ai.IBzState;
	
	import datas.objects.player.Stand;
	
	public class BzPlayer extends BzThinker
	{
		[Embed(source="../assets/sprite/django/32x64_stand_north.png")]
		private	static var _Idle_N	:Class;
		[Embed(source="../assets/sprite/django/32x64_stand_east.png")]
		private	static var _Idle_E	:Class;
		[Embed(source="../assets/sprite/django/32x64_stand_south.png")]
		private	static var _Idle_S	:Class;
		[Embed(source="../assets/sprite/django/32x64_stand_west.png")]
		private	static var _Idle_W	:Class;
		[Embed(source="../assets/sprite/django/32x64_run_north.png")]
		private	static var _Walk_N	:Class;
		[Embed(source="../assets/sprite/django/32x64_run_east.png")]
		private	static var _Walk_E	:Class;
		[Embed(source="../assets/sprite/django/32x64_run_south.png")]
		private	static var _Walk_S	:Class;
		[Embed(source="../assets/sprite/django/32x64_run_west.png")]
		private	static var _Walk_W	:Class;
		[Embed(source="../assets/sprite/django/32x64_jump_north.png")]
		private	static var _Jump_N	:Class;
		[Embed(source="../assets/sprite/django/32x64_jump_east.png")]
		private	static var _Jump_E	:Class;
		[Embed(source="../assets/sprite/django/32x64_jump_south.png")]
		private	static var _Jump_S	:Class;
		[Embed(source="../assets/sprite/django/32x64_jump_west.png")]
		private	static var _Jump_W	:Class;
		[Embed(source="../assets/sprite/django/32x64_fall_north.png")]
		private	static var _Fall_N	:Class;
		[Embed(source="../assets/sprite/django/32x64_fall_east.png")]
		private	static var _Fall_E	:Class;
		[Embed(source="../assets/sprite/django/32x64_fall_south.png")]
		private	static var _Fall_S	:Class;
		[Embed(source="../assets/sprite/django/32x64_fall_west.png")]
		private	static var _Fall_W	:Class;
		[Embed(source="../assets/sprite/django/32x64_crouch_north.png")]
		private	static var _Crouch_N:Class;
		[Embed(source="../assets/sprite/django/32x64_crouch_east.png")]
		private	static var _Crouch_E:Class;
		[Embed(source="../assets/sprite/django/32x64_crouch_south.png")]
		private	static var _Crouch_S:Class;
		[Embed(source="../assets/sprite/django/32x64_crouch_west.png")]
		private	static var _Crouch_W:Class;
		[Embed(source="../assets/sprite/django/32x64_standup_north.png")]
		private	static var _Standup_N:Class;
		[Embed(source="../assets/sprite/django/32x64_standup_east.png")]
		private	static var _Standup_E:Class;
		[Embed(source="../assets/sprite/django/32x64_standup_south.png")]
		private	static var _Standup_S:Class;
		[Embed(source="../assets/sprite/django/32x64_standup_west.png")]
		private	static var _Standup_W:Class;
		[Embed(source="../assets/sprite/django/32x64_grab_north.png")]
		private	static var _Grab_N:Class;
		[Embed(source="../assets/sprite/django/32x64_grab_east.png")]
		private	static var _Grab_E:Class;
		[Embed(source="../assets/sprite/django/32x64_grab_south.png")]
		private	static var _Grab_S:Class;
		[Embed(source="../assets/sprite/django/32x64_grab_west.png")]
		private	static var _Grab_W:Class;
		[Embed(source="../assets/sprite/django/32x64_pull_north.png")]
		private	static var _Pull_N:Class;
		[Embed(source="../assets/sprite/django/32x64_pull_east.png")]
		private	static var _Pull_E:Class;
		[Embed(source="../assets/sprite/django/32x64_pull_south.png")]
		private	static var _Pull_S:Class;
		[Embed(source="../assets/sprite/django/32x64_pull_west.png")]
		private	static var _Pull_W:Class;
		[Embed(source="../assets/sprite/django/64x64_die_north.png")]
		private	static var _Die_N:Class;
		[Embed(source="../assets/sprite/django/64x64_die_east.png")]
		private	static var _Die_E:Class;
		[Embed(source="../assets/sprite/django/64x64_die_south.png")]
		private	static var _Die_S:Class;
		[Embed(source="../assets/sprite/django/64x64_die_west.png")]
		private	static var _Die_W:Class;
		
		private	static var _idle_n	:BzSprite	= new BzSprite(new _Idle_N().bitmapData, 32, 64,-16,0, 0.1, false);
		private	static var _idle_e	:BzSprite	= new BzSprite(new _Idle_E().bitmapData, 32, 64,-16,0, 0.1, false);
		private	static var _idle_s	:BzSprite	= new BzSprite(new _Idle_S().bitmapData, 32, 64,-16,0, 0.1, false);
		private	static var _idle_w	:BzSprite	= new BzSprite(new _Idle_W().bitmapData, 32, 64,-16,0, 0.1, false);
		private	static var _walk_n	:BzSprite	= new BzSprite(new _Walk_N().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _walk_e	:BzSprite	= new BzSprite(new _Walk_E().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _walk_s	:BzSprite	= new BzSprite(new _Walk_S().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _walk_w	:BzSprite	= new BzSprite(new _Walk_W().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _jump_n	:BzSprite	= new BzSprite(new _Jump_N().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _jump_e	:BzSprite	= new BzSprite(new _Jump_E().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _jump_s	:BzSprite	= new BzSprite(new _Jump_S().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _jump_w	:BzSprite	= new BzSprite(new _Jump_W().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _fall_n	:BzSprite	= new BzSprite(new _Fall_N().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _fall_e	:BzSprite	= new BzSprite(new _Fall_E().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _fall_s	:BzSprite	= new BzSprite(new _Fall_S().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _fall_w	:BzSprite	= new BzSprite(new _Fall_W().bitmapData, 32, 64,-16,0, 0.3, false);
		private	static var _crouch_n:BzSprite	= new BzSprite(new _Crouch_N().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _crouch_e:BzSprite	= new BzSprite(new _Crouch_E().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _crouch_s:BzSprite	= new BzSprite(new _Crouch_S().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _crouch_w:BzSprite	= new BzSprite(new _Crouch_W().bitmapData, 32, 64,-16,0, 1, false);
		private	static var _standup_n:BzSprite	= new BzSprite(new _Standup_N().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _standup_e:BzSprite	= new BzSprite(new _Standup_E().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _standup_s:BzSprite	= new BzSprite(new _Standup_S().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _standup_w:BzSprite	= new BzSprite(new _Standup_W().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _grab_n	:BzSprite	= new BzSprite(new _Grab_N().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _grab_e	:BzSprite	= new BzSprite(new _Grab_E().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _grab_s	:BzSprite	= new BzSprite(new _Grab_S().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _grab_w	:BzSprite	= new BzSprite(new _Grab_W().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _pull_s	:BzSprite	= new BzSprite(new _Pull_N().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _pull_w	:BzSprite	= new BzSprite(new _Pull_E().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _pull_n	:BzSprite	= new BzSprite(new _Pull_S().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _pull_e	:BzSprite	= new BzSprite(new _Pull_W().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _push_n	:BzSprite	= new BzSprite(new _Pull_N().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _push_e	:BzSprite	= new BzSprite(new _Pull_E().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _push_s	:BzSprite	= new BzSprite(new _Pull_S().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _push_w	:BzSprite	= new BzSprite(new _Pull_W().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _die_n	:BzSprite	= new BzSprite(new _Die_N().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_e	:BzSprite	= new BzSprite(new _Die_E().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_s	:BzSprite	= new BzSprite(new _Die_S().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_w	:BzSprite	= new BzSprite(new _Die_W().bitmapData, 64, 64,0,0, 0.3, false, false);
		
		public function BzPlayer(id:String, x:int, y:int, z:int)
		{
			var state_idle		:BzSheet = new BzSheet(BzSheetType.IDLE, _idle_n, _idle_e, _idle_s, _idle_w);
			var state_walk		:BzSheet = new BzSheet(BzSheetType.WALK, _walk_n, _walk_e, _walk_s, _walk_w);
			var state_jump		:BzSheet = new BzSheet(BzSheetType.JUMP, _jump_n, _jump_e, _jump_s, _jump_w);
			var state_fall		:BzSheet = new BzSheet(BzSheetType.FALL, _fall_n, _fall_e, _fall_s, _fall_w);
			var state_crouch	:BzSheet = new BzSheet(BzSheetType.CROUCH, _crouch_n, _crouch_e, _crouch_s, _crouch_w);
			var state_standup	:BzSheet = new BzSheet(BzSheetType.STANDUP, _standup_n, _standup_e, _standup_s, _standup_w);
			var state_grab		:BzSheet = new BzSheet(BzSheetType.GRAB, _grab_n, _grab_e, _grab_s, _grab_w);
			var state_pull		:BzSheet = new BzSheet(BzSheetType.PULL, _pull_n, _pull_e, _pull_s, _pull_w);
			var state_push		:BzSheet = new BzSheet(BzSheetType.PUSH, _push_n, _push_e, _push_s, _push_w);
			var state_dead		:BzSheet = new BzSheet(BzSheetType.DEAD, _die_n, _die_e, _die_s, _die_w);
			
			var sets:BzSet = new BzSet("PLAYER");
			sets.addState(state_idle);
			sets.addState(state_walk);
			sets.addState(state_jump);
			sets.addState(state_fall);
			sets.addState(state_crouch);
			sets.addState(state_standup);
			sets.addState(state_grab);
			sets.addState(state_pull);
			sets.addState(state_push);
			sets.addState(state_dead);

			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z,1,1,1), Stand.getInstance());
		}
	}
}