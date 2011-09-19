package buzzler.data.primitives
{
	import buzzler.core.BzRectangle;
	import buzzler.data.BzElement;
	import buzzler.data.BzSet;
	
	public class BzParticle extends BzElement
	{
		public function BzParticle(sets:BzSet, state:String, rect:BzRectangle)
		{
			super(sets, state, rect);
		}
	}
}