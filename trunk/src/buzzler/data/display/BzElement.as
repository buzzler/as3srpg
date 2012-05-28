package buzzler.data.display
{
	import buzzler.consts.BzTile;
	import buzzler.core.BzScene;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.BzSet;
	import buzzler.data.BzSheet;
	import buzzler.system.BzElementDetector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class BzElement
	{
		private	var _id			:String;
		private	var _tagged		:Boolean;
		private	var _scene		:BzScene;
		private	var _rect		:BzRectangle;
		private	var _rotation	:BzRotation;
		private	var _views		:Dictionary;
		private	var _sets		:BzSet;
		private	var _current	:BzSheet;

		public	function BzElement(id:String, sets:BzSet, state:String, aabb:BzRectangle)
		{
			if (!sets.containByType(state))
			{
				throw new Error("알수없는 state값 입니다. BzSet 객체에 선언된 state만 가질 수 있습니다.");
				return;
			}

			_id			= id;
			_tagged		= false;
			_scene		= null;
			_rect		= aabb.clone();
			_rotation	= new BzRotation(BzRotation.NORTH);
			_views		= new Dictionary();
			_sets		= sets;
			_current	= sets.getState(state);

			setPosition(_rect.x, _rect.y, _rect.z);
		}
		
		public	function getId():String
		{
			return _id;
		}
		
		public	function tag():void
		{
			_tagged = true;
		}
		
		public	function untag():void
		{
			_tagged = false;
		}
		
		public	function isTagged():Boolean
		{
			return _tagged;
		}

		public	function setBzScene(scene:BzScene):void
		{
			_scene = scene;
		}
		
		public	function getBzScene():BzScene
		{
			return _scene;
		}
		
		public	function setSheetType(type:String):void
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
		
		public	function getBzSheet():BzSheet
		{
			return _current;
		}
		
		public	function getBzRectangle():BzRectangle
		{
			return _rect;
		}
		
		public	function addPosition(offsetX:Number, offsetY:Number, offsetZ:Number):void
		{
			setPosition(_rect.x+offsetX, _rect.y+offsetY, _rect.z+offsetZ);
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
		
		public	function getBzDisplayObjects():Dictionary
		{
			return _views;
		}
	}
}