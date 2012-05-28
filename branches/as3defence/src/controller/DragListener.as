package controller
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	public class DragListener
	{
		private	static var _this:DragListener;
		public	static function getInstance():DragListener
		{
			if (_this==null)
			{
				_this = new DragListener();
			}
			return _this;
		}
		
		private	var _dcenter	:DataCenter;
		private	var _draggable	:DisplayObject;
		private	var _origin		:Point;
		
		public	function startDragListening(draggable:DisplayObject):void
		{
			stopDragListening();

			_dcenter = DataCenter.getInstance();
			_draggable = draggable;
			_draggable.addEventListener(Event.ENTER_FRAME, onListen);
		}
		
		public	function stopDragListening():void
		{
			if (_draggable)
			{
				_draggable.removeEventListener(Event.ENTER_FRAME, onListen);
				_draggable.removeEventListener(Event.ENTER_FRAME, onDrag);
				_draggable = null;
				_dcenter = null;
				_origin = null;
			}
		}
		
		private	function onListen(event:Event):void
		{
			if (_dcenter.touch_drag)
			{
				_origin = new Point(_draggable.x, _draggable.y);
				_draggable.removeEventListener(Event.ENTER_FRAME,	onListen);
				_draggable.addEventListener(Event.ENTER_FRAME,		onDrag);
			}
		}
		
		private	function onDrag(event:Event):void
		{
			if (!_dcenter.touch_drag)
			{
				_draggable.removeEventListener(Event.ENTER_FRAME,	onDrag);
				_draggable.addEventListener(Event.ENTER_FRAME,		onListen);
				return;
			}
			
			_draggable.x = _origin.x+_dcenter.touch_dist.x;
			_draggable.y = _origin.y+_dcenter.touch_dist.y;
		}
	}
}