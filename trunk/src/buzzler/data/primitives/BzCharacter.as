package buzzler.data.primitives
{
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzSet;
	
	public class BzCharacter extends BzElement
	{
		public function BzCharacter(sets:BzSet, state:String, rect:BzRectangle)
		{
			super(sets, state, rect);
		}
	}
}