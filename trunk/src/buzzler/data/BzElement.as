package buzzler.data
{
	import buzzler.consts.BzTile;
	import buzzler.core.BzCell;
	import buzzler.core.BzMap;
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
		private			var _position	:Vector3D;
		private			var _rotation	:BzRotation;
		private			var _views		:Dictionary;
		private			var _sets		:BzSet;
		private			var _current	:BzState;

		public	function BzElement(sets:BzSet, state:String, x:int, y:int, z:int, rotation:int)
		{
			if (!sets.containByType(state))
			{
				throw new Error("알수없는 state값 입니다. BzSet 객체에 선언된 state만 가질 수 있습니다.");
				return;
			}
			
			_scene		= null;
			_position	= new Vector3D();
			_rotation	= new BzRotation(rotation);
			_views		= new Dictionary();
			_sets		= sets;
			_current	= sets.getState(state);

			setPosition(x, y, z);
		}

		public	function setBzScene(scene:BzScene):void
		{
			_scene = scene;
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
		
		public	function setPosition(x:Number, y:Number, z:Number):void
		{
			_position.x = x;
			_position.y = y;
			_position.z = z;

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
			return _position;
		}
		
		public	function setRotation(rotation:int):void
		{
			if (_rotation.getValue() != rotation)
			{
				_rotation.setValue(rotation);
				
				for each (var view:BzDisplayObject in _views)
				{
					view.setRotateFlag();
				}
			}
		}
		
		public	function getRotation():BzRotation
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