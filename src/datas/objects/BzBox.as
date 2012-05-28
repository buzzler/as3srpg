package datas.objects
{
	import buzzler.consts.BzSheetType;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.data.BzSprite;
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzTerrain;
	import buzzler.data.display.BzThinker;
	
	import datas.Block;
	import datas.objects.box.Ready;
	
	public class BzBox extends BzThinker
	{
		[Embed(source="../assets/sprite/object.png")]
		private	static var _Box	:Class;
		private	static var _sprite:BzSprite	= new BzSprite(new _Box().bitmapData, 64, 64,0,0);
		
		public function BzBox(id:String, x:int, y:int, z:int)
		{
			var state:BzSheet = new BzSheet(BzSheetType.IDLE, _sprite, _sprite, _sprite, _sprite);
			var sets:BzSet = new BzSet("BOX");
			sets.addState(state);
			
			super(id, sets, BzSheetType.IDLE, new BzRectangle(x,y,z), Ready.getInstance());
		}
	}
}