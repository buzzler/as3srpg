package buzzler.temp
{
	import buzzler.consts.BzStateType;
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSprite;
	import buzzler.data.BzState;
	
	public class BzGrass extends BzElement
	{
		[Embed(source="../assets/sprite/grass.png")]
		private	static var _Grass	:Class;
		private	static var _sprite	:BzSprite	= new BzSprite(new _Grass().bitmapData, 64, 64,0,0);
		
		public function BzGrass(x:int, y:int, z:int)
		{
			var state:BzState = new BzState(BzStateType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("GRASS");
			sets.addState(state);
			
			super(sets, BzStateType.IDLE, new BzRectangle(x,y,z));
		}
	}
}