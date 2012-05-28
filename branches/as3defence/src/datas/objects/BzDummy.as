package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzTerrain;
	
	public class BzDummy extends BzTerrain
	{
		[Embed(source="../assets/sprite/dummy.png")]
		private	static var _Dummy	:Class;
		private	static var _sprite:BzSprite	= new BzSprite(new _Dummy().bitmapData, 64, 64,0,0);
		
		public function BzDummy(id:String, x:int, y:int, z:int)
		{
			var state:BzSheet = new BzSheet(BzSheetType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("Dummy");
			sets.addState(state);
			
			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z));
		}
	}
}