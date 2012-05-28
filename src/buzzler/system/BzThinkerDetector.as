package buzzler.system
{
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzThinker;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class BzThinkerDetector extends BzElementDetector
	{
		private	var _thinkers	:Vector.<BzThinker>;
		
		public function BzThinkerDetector(width:int, height:int, depth:int)
		{
			super(width, height, depth);
			
			_thinkers	= new Vector.<BzThinker>();
		}
		
		public	function getThinker():Vector.<BzThinker>
		{
			return _thinkers;
		}
		
		public	function isThinker(element:BzElement):Boolean
		{
			return (_thinkers.indexOf(element) >= 0);
		}
		
		public	function addBzThinker(thinker:BzThinker):void
		{
			var index:int = _thinkers.indexOf(thinker);
			if (index < 0)
			{
				_thinkers.push(thinker);
				
				super.addBzElement(thinker as BzElement);
			}
		}
		
		public	function removeBzThinker(thinker:BzThinker):void
		{
			var index:int = _thinkers.indexOf(thinker);
			if (index > 0)
			{
				_thinkers.splice(index, 1);
				
				super.removeBzElement(thinker as BzElement);
			}
		}
		
		public	function moveBzThinker(thinker:BzThinker):Boolean
		{
			var index:int = _thinkers.indexOf(thinker);
			if (index >= 0)
			{
				return super.moveBzElement(thinker as BzElement);
			}
			return false;
		}
		
		public	function update():void
		{
			var thinker:BzThinker;
			for each (thinker in _thinkers)
			{
				thinker.getFSM().update();
			}
		}
	}
}