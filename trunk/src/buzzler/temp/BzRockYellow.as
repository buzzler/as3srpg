package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzRockYellow extends BzElement
	{
		[Embed(source="../assets/sprite/rock_type3.png")]
		private	static var _RockH	:Class;
		[Embed(source="../assets/sprite/rock_type5.png")]
		private	static var _RockV	:Class;
		private	static var _spriteH	:BzSprite	= new BzSprite(new _RockH().bitmapData, 96, 80,0,0);
		private	static var _spriteV	:BzSprite	= new BzSprite(new _RockV().bitmapData, 96, 80,32,0);
		
		public function BzRockYellow(x:int, y:int, z:int)
		{
			var state:BzState = new BzState(BzStateType.IDLE, _spriteH, _spriteV, _spriteH, _spriteV);
			var sets:BzSet = new BzSet("ROCKYELLOW");
			sets.addState(state);
			
			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z, 2, 1, 1));
		}
	}
}