package buzzler.data.display
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;

	public class BzGhost extends BzElement
	{
		public function BzGhost(id:String, sets:BzSet, state:String, aabb:BzRectangle)
		{
			super(id, sets, state, aabb);
		}
	}
}