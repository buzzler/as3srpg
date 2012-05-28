package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.display.BzElement;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzTerrain;
	
	import datas.Block;
	
	public class BzRock extends BzTerrain
	{
		[Embed(source="../assets/sprite/terrain_0.png")]
		private	static var _Rock_1	:Class;
		[Embed(source="../assets/sprite/terrain_1.png")]
		private	static var _Rock_2	:Class;
		private	static var _sprite_1:BzSprite	= new BzSprite(new _Rock_1().bitmapData, 64, 64,0,0);
		private	static var _sprite_2:BzSprite	= new BzSprite(new _Rock_2().bitmapData, 64, 64,0,0);
		
		public function BzRock(id:String, x:int, y:int, z:int)
		{
			var sprite	:BzSprite	= (Math.random() < 0.5) ? _sprite_1:_sprite_2;
			var state	:BzSheet	= new BzSheet(BzSheetType.IDLE, sprite, sprite, sprite, sprite);
			var sets	:BzSet		= new BzSet("ROCK");
			sets.addState(state);

			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z));
		}
	}
}