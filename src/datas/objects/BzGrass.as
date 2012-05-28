package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzGhost;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	
	import datas.Block;
	
	public class BzGrass extends BzGhost
	{
		[Embed(source="../assets/sprite/ghost.png")]
		private	static var _Grass	:Class;
		private	static var _sprite	:BzSprite	= new BzSprite(new _Grass().bitmapData, 64, 64,0,0);
		
		public function BzGrass(id:String, x:int, y:int, z:int)
		{
			var state:BzSheet = new BzSheet(BzSheetType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("GRASS");
			sets.addState(state);
			
			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z));
		}
	}
}