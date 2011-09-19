package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzRockMagenta extends BzElement
	{
		[Embed(source="../assets/sprite/rock_type8.png")]
		private	static var _RockH	:Class;
		[Embed(source="../assets/sprite/rock_type9.png")]
		private	static var _RockV	:Class;
		private	static var _spriteH	:BzSprite	= new BzSprite(new _RockH().bitmapData, 128, 96,0,0);
		private	static var _spriteV	:BzSprite	= new BzSprite(new _RockV().bitmapData, 128, 96,64,0);
		
		public function BzRockMagenta(x:int, y:int, z:int)
		{
			var state:BzState = new BzState(BzStateType.IDLE, _spriteH, _spriteV, _spriteH, _spriteV);
			var sets:BzSet = new BzSet("ROCKCYAN");
			sets.addState(state);
			
			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z, 3, 1, 1));
		}
	}
}