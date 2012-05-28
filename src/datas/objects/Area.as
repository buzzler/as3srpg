package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzUnit;
	import buzzler.system.ai.IBzState;
	
	public class Area extends BzUnit
	{
		[Embed(source="../assets/sprite/area_r.png")]
		private	static var _Red		:Class;
		[Embed(source="../assets/sprite/area_g.png")]
		private	static var _Green	:Class;
		[Embed(source="../assets/sprite/area_b.png")]
		private	static var _Blue	:Class;

		private	static var _sprite_r	:BzSprite = new BzSprite(new _Red().bitmapData, 64, 64,0,0);
		private	static var _sprite_g	:BzSprite = new BzSprite(new _Green().bitmapData, 64, 64,0,0);
		private	static var _sprite_b	:BzSprite = new BzSprite(new _Blue().bitmapData, 64, 64,0,0);
		
		public function Area(id:String, x:int, y:int, z:int, color:uint)
		{
			var sprite	:BzSprite	= (color==0xFF0000) ? _sprite_r: (color==0x0000FF)? _sprite_b:_sprite_g;
			var state	:BzSheet	= new BzSheet(BzSheetType.IDLE, sprite, sprite, sprite, sprite);
			var sets	:BzSet		= new BzSet("AREA");
			sets.addState(state);

			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z), null);
		}
	}
}