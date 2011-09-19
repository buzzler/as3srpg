package buzzler.core
{
	import buzzler.consts.BzTile;
	import buzzler.data.BzDisplayObject;
	import buzzler.data.BzElement;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.net.dns.AAAARecord;
	import flash.utils.Dictionary;
	
	public class BzViewport extends Sprite
	{
		private	var _camera				:BzCamera;
		private	var _views				:Vector.<BzDisplayObject>;
		private	var _reserve_update		:Boolean;
		private var _reserve_position	:Boolean;
		private var _reserve_rotation	:Boolean;
		private var _reserve_state		:Boolean;
		private	var _reserve_sort		:Boolean;
		
		/**
		 * temporary variables for sort
		 */		
		private var _behinds:Dictionary;
		private var _depth	:uint;
		private var _visit	:Dictionary;


		public	function BzViewport()
		{
			super();
			
			_views = new Vector.<BzDisplayObject>();
		}
		
		public	function setBzCamera(camera:BzCamera):void
		{
			_camera = camera;
		}
		
		public	function getBzCamera():BzCamera
		{
			return _camera;
		}
		
		public	function render():void
		{
			update();
			
			for each (var view:BzDisplayObject in _views)
			{
				if (view.getAndClearRotateFlag() || _reserve_rotation)
				{
					_camera.projectRotation(view.getGlobalRotation(), view);
					reserveState();
				}
				
				if (view.getAndClearStateFlag() || _reserve_state)
				{
					view.updateState();
					reserveProjectPosition();
				}
				
				if (view.getAndClearMoveFlag() || _reserve_position)
				{
					_camera.projectPosition(view.getGlobalPosition(), view);
				}
			}

			if (_reserve_sort)
			{
				sort();
			}
			
			_reserve_position = false;
			_reserve_rotation = false;
			_reserve_state = false;
			_reserve_sort = false;
		}
		
		public	function reserveState():void
		{
			_reserve_state = true;
		}
		
		public	function reserveProjectRotation():void
		{
			_reserve_rotation = true;
		}
		
		public	function reserveProjectPosition():void
		{
			_reserve_position = true;
		}
		
		public	function reserveUpdate():void
		{
			_reserve_update = true;
		}
		
		/**
		 *
		 * 여기를 BzRectangle의 union이나 intersect를 이용해서 효율적인 방법 선택한다.
		 * 현재의 코드는 바운더리 안의 모든 element에 대해서 스캔. 
		 * 
		 */		
		public	function update():void
		{
			if (_reserve_update)
			{
				var elements:Vector.<BzElement> = _camera.getBzElements();
				var element	:BzElement;
				var view	:BzDisplayObject;
				var views	:Vector.<BzDisplayObject> = new Vector.<BzDisplayObject>();

				for each (element in elements)
				{
					view = element.generateBzDisplayObject(this);
	
					var index:int = _views.indexOf(view);
					if (index >= 0)
					{
						_views.splice(index, 1);
					}
					else
					{
						addChild(view);
					}
					views.push(view);
				}
				
				for each (view in _views)
				{
					element = view.getBzElement();
					element.deleteBzDisplayObject(element);
					removeChild(view);
				}
				
				_views = views;
				
				_reserve_update = false;
				reserveSort();
			}
		}
		
		public	function reserveSort():void
		{
			_reserve_sort = true;
		}

		public	function sort():void
		{
			_behinds = new Dictionary();
			_visit = new Dictionary();
			
			for each (var viewA:BzDisplayObject in _views)
			{
				var behind:Vector.<BzDisplayObject> = new Vector.<BzDisplayObject>();
				var rectA:BzRectangle = viewA.getBzRectangle();
				for each (var viewB:BzDisplayObject in _views)
				{
					var rectB:BzRectangle = viewB.getBzRectangle();
					if ( (viewA.getBzRectangle().mass==1) && (viewB.getBzRectangle().mass==1) && (viewA!=viewB) )
					{
						var subZ:Number = rectA.z - rectB.z;
						var subXY:Number = (rectA.x+rectA.y) - (rectB.x+rectB.y);
						
						if (subXY>0)
						{
							behind.push(viewB);
						}
						else if (subXY==0 && subZ>0)
						{
							behind.push(viewB);
						}
					}
					else
					{
						if ( (rectB.lefti <= rectA.righti) && (rectB.topi <= rectA.bottomi) && (rectB.floori <= rectA.ceili) && (viewA != viewB) )
						{
							behind.push(viewB);
						}
					}
				}
				
				_behinds[viewA] = behind;
			}
			
			_depth = 0;
			for each (var obj:BzDisplayObject in _views)
			{
				if (true !== _visit[obj])
				{
					place(obj);
				}
			}
			
			_behinds = null;
			_visit = null;
		}
		
		private function place(view:BzDisplayObject):void
		{
			_visit[view] = true;
			
			for each(var behind:BzDisplayObject in _behinds[view])
			{
				if(true !== _visit[behind])
				{
					place(behind);
				}
			}
			
			if (_depth != getChildIndex(view))
			{
				setChildIndex(view, _depth);
			}
			
			++_depth;
		}
	}
}