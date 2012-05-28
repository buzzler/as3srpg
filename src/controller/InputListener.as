package controller
{
	import buzzler.data.display.BzDisplayObject;
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzUnit;
	import buzzler.data.display.iBzTouchable;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class InputListener
	{
		private	static var _instance:InputListener;
		public	static function getInstance():InputListener
		{
			if (_instance == null)
				_instance = new InputListener();
			return _instance;
		}
		
		private	var _dcenter	:DataCenter;
		private	var _currentKey	:InteractiveObject;
		private	var _stackKey	:Vector.<InteractiveObject>;
		
		public	function InputListener():void
		{
			_dcenter = DataCenter.getInstance();
			_stackKey = new Vector.<InteractiveObject>();
		}
		
		public	function startKeyListening(target:InteractiveObject):void
		{
			if (_currentKey)
			{
				removeKeyListener(_currentKey);
				_stackKey.push(_currentKey);
			}
			
			_currentKey = target;
			if (_currentKey)
			{
				addKeyListener(_currentKey);
			}
		}
		
		public	function stopKeyListening():void
		{
			if (_currentKey)
			{
				removeKeyListener(_currentKey);
			}
			
			_currentKey = _stackKey.pop();
			if (_currentKey)
			{
				addKeyListener(_currentKey);
			}
		}
		
		public	function stopKeyListeningAll():void
		{
			if (_currentKey)
			{
				removeKeyListener(_currentKey);
			}
			
			_currentKey = null;
			_stackKey.length = 0;
		}
		
		private	function addKeyListener(target:InteractiveObject):void
		{
			target.addEventListener(KeyboardEvent.KEY_DOWN,	onKeyDown);
			target.addEventListener(KeyboardEvent.KEY_UP,	onKeyUp);
//			target.addEventListener(MouseEvent.CLICK,		onClick);
			target.addEventListener(MouseEvent.MOUSE_DOWN,	onDown);
		}
		
		private	function removeKeyListener(target:InteractiveObject):void
		{
			target.removeEventListener(KeyboardEvent.KEY_DOWN,	onKeyDown);
			target.removeEventListener(KeyboardEvent.KEY_UP,	onKeyUp);
//			target.removeEventListener(MouseEvent.CLICK,		onClick);
			target.removeEventListener(MouseEvent.MOUSE_DOWN,	onDown);
		}
		
		private	function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			case Keyboard.LEFT:
			case Keyboard.A:
				_dcenter.key_left = true;
				break;
			case Keyboard.RIGHT:
			case Keyboard.D:
				_dcenter.key_right = true;
				break;
			case Keyboard.UP:
			case Keyboard.W:
				_dcenter.key_up = true;
				break;
			case Keyboard.DOWN:
			case Keyboard.S:
				_dcenter.key_down = true;
				break;
			case Keyboard.SPACE:
				_dcenter.key_space = true;
				break;
			case Keyboard.COMMA:
				_dcenter.key_crouch = true;
				break;
			case Keyboard.PERIOD:
				_dcenter.key_grab = true;
				break;
			}
		}
		
		private	function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.LEFT:
				case Keyboard.A:
					_dcenter.key_left = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					_dcenter.key_right = false;
					break;
				case Keyboard.UP:
				case Keyboard.W:
					_dcenter.key_up = false;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					_dcenter.key_down = false;
					break;
				case Keyboard.SPACE:
					_dcenter.key_space = false;
					break;
				case Keyboard.COMMA:
					_dcenter.key_crouch = false;
					break;
				case Keyboard.PERIOD:
					_dcenter.key_grab = false;
					break;
			}
		}
		
		private	function onDown(event:MouseEvent):void
		{
			var dcenter:DataCenter	= DataCenter.getInstance();
			dcenter.touch_origin	= new Point(_currentKey.mouseX, _currentKey.mouseY);
			dcenter.touch_dist		= new Point();
			
			_currentKey.addEventListener(MouseEvent.MOUSE_UP,	onUp);
			_currentKey.addEventListener(Event.ENTER_FRAME,		onPressing);
		}
		
		private	function onPressing(event:Event):void
		{
			var dcenter:DataCenter = DataCenter.getInstance();
			dcenter.touch_dist.x = _currentKey.mouseX - dcenter.touch_origin.x;
			dcenter.touch_dist.y = _currentKey.mouseY - dcenter.touch_origin.y;
			
			if ((dcenter.touch_dist.length>5) && (!dcenter.touch_drag))
			{
				dcenter.touch_drag = true;
			}
		}
		
		private	function onUp(event:MouseEvent):void
		{
			_currentKey.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			_currentKey.removeEventListener(Event.ENTER_FRAME,	onPressing);
			
			var dcenter:DataCenter = DataCenter.getInstance();
			if (dcenter.touch_drag)
			{
				dcenter.touch_drag = false;
			}
			else
			{
				var container:DisplayObjectContainer = _currentKey as DisplayObjectContainer;
				var pointG:Point = new Point(event.stageX, event.stageY);
				var pointL:Point;
				
				var under:Array = container.getObjectsUnderPoint(pointG);
				for (var i:int = under.length - 1 ; i >= 0 ; i--)
				{
					var child:BzDisplayObject = under[i] as BzDisplayObject;
					if (child)
					{
						var model:iBzTouchable = child.getBzElement() as iBzTouchable;
						if (model)
						{
							pointL = child.globalToLocal(pointG);
							if(child.bitmapData.getPixel32(pointL.x, pointL.y) > 0x00FFFFFF)
							{
								model.setTouchFlag();
								
								// for test
								if (child.filters.length == 0)
									child.filters = [new GlowFilter(0xff0000)];
								else
									child.filters = [];
								return;
							}
						}
					}
				}
			}
		}
		
		private	function onClick(event:MouseEvent):void
		{
			var container:DisplayObjectContainer = _currentKey as DisplayObjectContainer;
			var pointG:Point = new Point(event.stageX, event.stageY);
			var pointL:Point;

			var under:Array = container.getObjectsUnderPoint(pointG);
			for (var i:int = under.length - 1 ; i >= 0 ; i--)
			{
				var child:BzDisplayObject = under[i] as BzDisplayObject;
				if (child)
				{
					var model:iBzTouchable = child.getBzElement() as iBzTouchable;
					if (model)
					{
						pointL = child.globalToLocal(pointG);
						if(child.bitmapData.getPixel32(pointL.x, pointL.y) > 0x00FFFFFF)
						{
							model.setTouchFlag();
							
							// for test
							if (child.filters.length == 0)
								child.filters = [new GlowFilter(0xff0000)];
							else
								child.filters = [];
							return;
						}
					}
				}
			}
		}
	}
}