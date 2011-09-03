package buzzler.core
{
	import buzzler.data.BzElement;
	
	import flash.geom.Vector3D;

	public class BzScene
	{
		private	var _bound		:Vector3D;
		private	var _elements	:Vector.<BzElement>;
		private	var _camera		:Vector.<BzCamera>;
		private	var _map		:BzMap;
		
		public	function BzScene(bound:Vector3D)
		{
			_bound		= bound;
			_camera		= new Vector.<BzCamera>();
			_elements	= new Vector.<BzElement>();
			_map		= new BzMap(_bound.x, _bound.y, _bound.z);
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
					var p:Vector3D = element.getPosition();
					if ( camera.contain(p.x, p.y, p.z) )
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
					var p:Vector3D = element.getPosition();
					if ( camera.contain(p.x, p.y, p.z) )
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
				var fromCell:BzCell = _map.whichBzCell(element);
				if (fromCell == null)
				{
					return;
				}
				
				_map.moveBzElement(element);
				
				var toCell:BzCell = _map.whichBzCell(element);
				if (toCell == null)
				{
					return;
				}
				
				for each (var camera:BzCamera in _camera)
				{
					var fromCamera:Boolean = camera.contain(fromCell.x, fromCell.y, fromCell.z);
					var toCamera:Boolean = camera.contain(toCell.x, toCell.y, toCell.z);
					
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
		
		public	function render():void
		{
			for each (var camera:BzCamera in _camera)
			{
				camera.render();
			}
		}
		
		public	function getPath(origin:Vector3D, dest:Vector3D):Vector.<BzCell>
		{
			return _map.solve(origin, dest);
		}
	}
}