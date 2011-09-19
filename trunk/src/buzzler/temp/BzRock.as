package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzRock extends BzElement
	{
		[Embed(source="../assets/sprite/rock_type0.png")]
		private	static var _Rock_1	:Class;
		[Embed(source="../assets/sprite/rock_type1.png")]
		private	static var _Rock_2	:Class;
		private	static var _sprite_1:BzSprite	= new BzSprite(new _Rock_1().bitmapData, 64, 64,0,0);
		private	static var _sprite_2:BzSprite	= new BzSprite(new _Rock_2().bitmapData, 64, 64,0,0);
		
		public function BzRock(x:int, y:int, z:int)
		{
			var _sprite:BzSprite;
			if (Math.random() < 0.5)
				_sprite = _sprite_1;
			else
				_sprite = _sprite_2;
			var state:BzState = new BzState(BzStateType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("ROCK");
			sets.addState(state);

			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z));
		}
	}
}