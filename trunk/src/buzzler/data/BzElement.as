package buzzler.data
{
	import buzzler.consts.BzTile;
	import buzzler.core.BzCell;
	import buzzler.core.BzMap;
	import buzzler.core.BzRectangle;
	import buzzler.core.BzScene;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class BzElement
	{
		private	static	var _hash		:Dictionary = new Dictionary();
		private			var _scene		:BzScene;
		private			var _rect		:BzRectangle;
		private			var _rotation	:BzRotation;
		private			var _views		:Dictionary;
		private			var _sets		:BzSet;
		private			var _current	:BzState;

		public	function BzElement(sets:BzSet, state:String, rect:BzRectangle)
		{
			if (!sets.containByType(state))
			{
				throw new Error("알수없는 state값 입니다. BzSet 객체에 선언된 state만 가질 수 있습니다.");
				return;
			}
			
			_scene		= null;
			_rect		= rect.clone();
			_rotation	= new BzRotation(BzRotation.NORTH);
			_views		= new Dictionary();
			_sets		= sets;
			_current	= sets.getState(state);

			setPosition(_rect.x, _rect.y, _rect.z);
		}

		public	function setBzScene(scene:BzScene):void
		{
			_scene = scene;
		}
		
		public	function getBzScene():BzScene
		{
			return _scene;
		}
		
		public	function setState(type:String):void
		{
			if (!_sets.containByType(type))
			{
				throw new Error("알수없는 state값 입니다. BzSet 객체에 선언된 state만 가질 수 있습니다.");
				return;
			}
			
			if (_current.getType() != type)
			{
				_current = _sets.getState(type);
				
				for each (var view:BzDisplayObject in _views)
				{
					view.setStateFlag();
				}
			}
		}
		
		public	function getState():BzState
		{
			return _current;
		}
		
		public	function getBzRectangle():BzRectangle
		{
			return _rect;
		}
		
		public	function setPosition(x:Number, y:Number, z:Number):void
		{
			_rect.x = x;
			_rect.y = y;
			_rect.z = z;

			for each (var view:BzDisplayObject in _views)
			{
				view.setMoveFlag();
			}
			
			if (_scene)
			{
				_scene.moveBzElement(this);
			}
		}

		public	function getPosition():Vector3D
		{
			return _rect.topLeftFloor;
		}
		
		public	function setRotation(rotation:int):void
		{
			if (_rotation.getValue() != rotation)
			{
				if ( Math.abs(_rotation.getValue()-rotation) != 180 )
				{
					var w:Number	= _rect.width;
					var h:Number	= _rect.height;

					_rect.width		= h;
					_rect.height	= w;
				}
				
				_rotation.setValue(rotation);
				
				for each (var view:BzDisplayObject in _views)
				{
					view.setRotateFlag();
				}
				
				if (_scene)
				{
					_scene.moveBzElement(this);
				}
			}
		}
		
		public	function getBzRotation():BzRotation
		{
			return _rotation;
		}

		public	function generateBzDisplayObject(key:Object):BzDisplayObject
		{
			if (key)
			{
				var result:BzDisplayObject = _views[key] as BzDisplayObject;
				if (result == null)
				{
					result = new BzDisplayObject(this);
					_views[key] = result;
				}
				return result;
			}
			return null;
		}
		
		public	function deleteBzDisplayObject(key:Object):void
		{
			if (key)
			{
				var value:BzDisplayObject = _views[key] as BzDisplayObject;
				if (value)
				{
					value.clear();
					delete _views[key];
				}
			}
		}
	}
}