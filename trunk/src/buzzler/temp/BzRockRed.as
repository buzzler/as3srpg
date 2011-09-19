package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzRockRed extends BzElement
	{
		[Embed(source="../assets/sprite/rock_type2.png")]
		private	static var _Rock_2	:Class;
		private	static var _sprite_2:BzSprite	= new BzSprite(new _Rock_2().bitmapData, 128, 128,32,32);
		
		public function BzRockRed(x:int, y:int, z:int)
		{
			var state:BzState = new BzState(BzStateType.IDLE, _sprite_2, _sprite_2, _sprite_2, _sprite_2);
			var sets:BzSet = new BzSet("ROCKRED");
			sets.addState(state);
			
			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z, 2, 2, 2));
		}
	}
}