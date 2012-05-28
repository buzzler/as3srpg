package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzThinker;
	import buzzler.data.display.BzUnit;
	import buzzler.system.BzElementDetector;
	import buzzler.system.ai.IBzState;
	
	import datas.Skill;
	import datas.objects.units.Normal;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.BreakElement;
	
	
	public class UnitFighter extends UnitBase
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
		[Embed(source="../assets/sprite/django/64x64_die_north.png")]
		private	static var _Die_N:Class;
		[Embed(source="../assets/sprite/django/64x64_die_east.png")]
		private	static var _Die_E:Class;
		[Embed(source="../assets/sprite/django/64x64_die_south.png")]
		private	static var _Die_S:Class;
		[Embed(source="../assets/sprite/django/64x64_die_west.png")]
		private	static var _Die_W:Class;
		[Embed(source="../assets/sprite/django/64x64_swing_north.png")]
		private	static var _Swing_N:Class;
		[Embed(source="../assets/sprite/django/64x64_swing_east.png")]
		private	static var _Swing_E:Class;
		[Embed(source="../assets/sprite/django/64x64_swing_south.png")]
		private	static var _Swing_S:Class;
		[Embed(source="../assets/sprite/django/64x64_swing_west.png")]
		private	static var _Swing_W:Class;
		[Embed(source="../assets/sprite/django/32x64_punch_north.png")]
		private	static var _Punch_N:Class;
		[Embed(source="../assets/sprite/django/32x64_punch_east.png")]
		private	static var _Punch_E:Class;
		[Embed(source="../assets/sprite/django/32x64_punch_south.png")]
		private	static var _Punch_S:Class;
		[Embed(source="../assets/sprite/django/32x64_punch_west.png")]
		private	static var _Punch_W:Class;
		
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
		private	static var _die_n	:BzSprite	= new BzSprite(new _Die_N().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_e	:BzSprite	= new BzSprite(new _Die_E().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_s	:BzSprite	= new BzSprite(new _Die_S().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _die_w	:BzSprite	= new BzSprite(new _Die_W().bitmapData, 64, 64,0,0, 0.3, false, false);
		private	static var _swing_n	:BzSprite	= new BzSprite(new _Swing_N().bitmapData, 64, 64,0,2, 0.2, false, false);
		private	static var _swing_e	:BzSprite	= new BzSprite(new _Swing_E().bitmapData, 64, 64,0,0, 0.2, false, false);
		private	static var _swing_s	:BzSprite	= new BzSprite(new _Swing_S().bitmapData, 64, 64,0,0, 0.2, false, false);
		private	static var _swing_w	:BzSprite	= new BzSprite(new _Swing_W().bitmapData, 64, 64,0,2, 0.2, false, false);
		private	static var _punch_n	:BzSprite	= new BzSprite(new _Punch_N().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _punch_e	:BzSprite	= new BzSprite(new _Punch_E().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _punch_s	:BzSprite	= new BzSprite(new _Punch_S().bitmapData, 32, 64,-16,0, 0.3, false, false);
		private	static var _punch_w	:BzSprite	= new BzSprite(new _Punch_W().bitmapData, 32, 64,-16,0, 0.3, false, false);
		
		public function UnitFighter(id:String, x:Number, y:Number, z:Number)
		{
			var state_idle		:BzSheet = new BzSheet(BzSheetType.IDLE, _idle_n, _idle_e, _idle_s, _idle_w);
			var state_walk		:BzSheet = new BzSheet(BzSheetType.WALK, _walk_n, _walk_e, _walk_s, _walk_w);
			var state_jump		:BzSheet = new BzSheet(BzSheetType.JUMP, _jump_n, _jump_e, _jump_s, _jump_w);
			var state_fall		:BzSheet = new BzSheet(BzSheetType.FALL, _fall_n, _fall_e, _fall_s, _fall_w);
			var state_crouch	:BzSheet = new BzSheet(BzSheetType.CROUCH, _crouch_n, _crouch_e, _crouch_s, _crouch_w);
			var state_standup	:BzSheet = new BzSheet(BzSheetType.STANDUP, _standup_n, _standup_e, _standup_s, _standup_w);
			var state_dead		:BzSheet = new BzSheet(BzSheetType.DEAD, _die_n, _die_e, _die_s, _die_w);
			var state_swing		:BzSheet = new BzSheet(BzSheetType.SKILL, _swing_n, _swing_e, _swing_s, _swing_w);
			var state_punch		:BzSheet = new BzSheet(BzSheetType.ATTACK, _punch_n, _punch_e, _punch_s, _punch_w);
			
			var sets:BzSet = new BzSet("PLAYER");
			sets.addState(state_idle);
			sets.addState(state_walk);
			sets.addState(state_jump);
			sets.addState(state_fall);
			sets.addState(state_crouch);
			sets.addState(state_standup);
			sets.addState(state_dead);
			sets.addState(state_swing);
			sets.addState(state_punch);
			
			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z,1,1,1), new Normal());
		}
	}
}