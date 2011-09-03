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
	
	public class BzViewport extends Sprite
	{
		private	var _camera				:BzCamera;
		private	var _views				:Vector.<BzDisplayObject>;
		private	var _reserve_update		:Boolean;
		private var _reserve_position	:Boolean;
		private var _reserve_rotation	:Boolean;
		private var _reserve_state		:Boolean;

		public	function BzViewport()
		{
			super();
			
			// for test
			this.graphics.lineStyle(1, 0xFF0000);
			this.graphics.lineTo(400,0);
			this.graphics.lineTo(400,300);
			this.graphics.lineTo(0,300);
			this.graphics.lineTo(0,0);
			// for test
			
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
			_reserve_position = false;
			_reserve_rotation = false;
			_reserve_state = false;
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
				
				sort();
				
				_reserve_update = false;
			}
		}
		
		public	function sort():void
		{
			_views = _views.sort(compBzDisplayObject);
			
			var depth:int = 0;
			for each (var view:BzDisplayObject in _views)
			{
				setChildIndex(view, depth++);
			}
		}
		
		private	function compBzDisplayObject(a:BzDisplayObject, b:BzDisplayObject):int
		{
			var subZ:Number = a.tileZ - b.tileZ;
			var subXY:Number = (a.tileX+a.tileY) - (b.tileX+b.tileY);

			if (subXY < 0)
				return -1;
			else if (subXY > 0)
				return 1;
			else
				return subZ;
		}
	}
}