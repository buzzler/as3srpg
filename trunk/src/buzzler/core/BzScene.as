package buzzler.core
{
	import buzzler.data.BzElement;
	import buzzler.system.BzRenderer;
	import buzzler.temp.BzRockYellow;
	
	import flash.geom.Vector3D;

	public class BzScene
	{
		private var _rect		:BzRectangle;
		private	var _elements	:Vector.<BzElement>;
		private	var _camera		:Vector.<BzCamera>;
		private	var _renderer	:BzRenderer;
		private	var _map		:BzMap;
		
		public	function BzScene(rect:BzRectangle)
		{
			_rect		= rect;
			_renderer	= new BzRenderer();
			_camera		= new Vector.<BzCamera>();
			_elements	= new Vector.<BzElement>();
			_map		= new BzMap(_rect.width, _rect.height, _rect.depth);
		}
		
		public	function addBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index < 0)
			{
				element.setBzScene(this);
				_elements.push(element);
				_map.addBzElement(element);
				
				for each (var camera:BzCamera in _camera)
				{
					if ( camera.containBzRectangle(element.getBzRectangle()) )
					{
						camera.addBzElement(element);
					}
				}
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
			{
				element.setBzScene(null);
				_elements.splice(index, 1);
				_map.removeBzElement(element);
				
				for each (var camera:BzCamera in _camera)
				{
					if ( camera.containBzRectangle(element.getBzRectangle()) )
					{
						camera.removeBzElement(element);
					}
				}
			}
		}
		
		public	function moveBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
			{
				var fromCell:Vector.<BzCell> = _map.whichBzCell(element);
				if (fromCell == null)
				{
					return;
				}
				
				if (!_map.moveBzElement(element))
				{
					return;
				}
				
				var toCell:Vector.<BzCell> = _map.whichBzCell(element);
				if (toCell == null)
				{
					return;
				}
				
				for each (var camera:BzCamera in _camera)
				{
					var fromCamera:Boolean = 
						camera.contain(fromCell[0].x, fromCell[0].y, fromCell[0].z) && 
						camera.contain(fromCell[fromCell.length-1].x, fromCell[fromCell.length-1].y, fromCell[fromCell.length-1].z);
					var toCamera:Boolean = 
						camera.contain(toCell[0].x, toCell[0].y, toCell[0].z) && 
						camera.contain(toCell[toCell.length-1].x, toCell[toCell.length-1].y, toCell[toCell.length-1].z);
					
					if (fromCamera && toCamera)
					{
						camera.sort();
					}
					else if (fromCamera != toCamera)
					{
						if (fromCamera)
							camera.removeBzElement(element);
						else if (toCamera)
							camera.addBzElement(element);
					}
					else
					{
						continue;
					}
				}
			}
		}
		
		public	function getBzElements():Vector.<BzElement>
		{
			return _elements;
		}
		
		public	function addBzCamera(camera:BzCamera):void
		{
			if (!containBzCamera(camera))
			{
				_camera.push(camera);
				camera.setBzScene(this);
				camera.reserveUpdate();
			}
		}
		
		public	function removeBzCamera(camera:BzCamera):void
		{
			if (containBzCamera(camera))
			{
				_camera.splice(_camera.indexOf(camera), 1);
				camera.setBzScene(null);
				camera.reserveUpdate();
			}
		}
		
		public	function containBzCamera(camera:BzCamera):Boolean
		{
			if (_camera.indexOf(camera) < 0)
				return false;
			else
				return true;
		}
		
		public	function getRenderer():BzRenderer
		{
			return _renderer;
		}
		
		public	function render():void
		{
			for each (var camera:BzCamera in _camera)
			{
				camera.render();
			}
			_renderer.exec();
		}
		
		public	function getBzMap():BzMap
		{
			return _map;
		}
		
		public	function getPath(origin:Vector3D, dest:Vector3D):Vector.<BzCell>
		{
			return _map.getPath(origin, dest);
		}
	}
}