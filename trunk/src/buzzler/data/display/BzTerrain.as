package buzzler.data.display
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;

	public class BzTerrain extends BzElement
	{
		public function BzTerrain(id:String, sets:BzSet, state:String, aabb:BzRectangle)
		{
			super(id, sets, state, aabb);
		}
	}
}