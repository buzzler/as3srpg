package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzRockBlue extends BzElement
	{
		[Embed(source="../assets/sprite/rock_type4.png")]
		private	static var _Rock	:Class;
		private	static var _sprite	:BzSprite	= new BzSprite(new _Rock().bitmapData, 64, 96,0,32);
		
		public function BzRockBlue(x:int, y:int, z:int)
		{
			var state:BzState = new BzState(BzStateType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("ROCKBLUE");
			sets.addState(state);
			
			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z, 1, 1, 2));
		}
	}
}