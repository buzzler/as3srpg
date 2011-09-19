package buzzler.data.primitives
{
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzSet;
	
	public class BzTerrain extends BzElement
	{
		public function BzTerrain(sets:BzSet, state:String, rect:BzRectangle)
		{
			super(sets, state, rect);
		}
	}
}