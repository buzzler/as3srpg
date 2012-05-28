package buzzler.core
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzTerrain;
	import buzzler.data.display.BzThinker;
	import buzzler.system.BzRenderer;
	import buzzler.system.BzThinkerDetector;
	import buzzler.system.BzElementDetector;

	import flash.geom.Vector3D;

	import flashx.textLayout.elements.BreakElement;

	public class BzScene
	{
		private var _rect		:BzRectangle;
		private	var _elements	:Vector.<BzElement>;
		private	var _camera		:Vector.<BzCamera>;
		private	var _renderer	:BzRenderer;
		private	var _detectorV	:BzElementDetector;
		private	var _detectorT	:BzThinkerDetector;
		
		public	function BzScene(rect:BzRectangle)
		{
			_rect		= rect;
			_renderer	= new BzRenderer();
			_camera		= new Vector.<BzCamera>();
			_elements	= new Vector.<BzElement>();
			_detectorV	= new BzElementDetector(_rect.width, _rect.height, _rect.depth);
			_detectorT	= new BzThinkerDetector(_rect.width, _rect.height, _rect.depth);
		}
		
		public	function addBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index < 0)
			{
				element.setBzScene(this);
				_elements.push(element);
				
				if (element is BzThinker)
				{
					_detectorT.addBzThinker(element as BzThinker);
				}	
				else if (element is BzTerrain)
				{
					_detectorV.addBzElement(element);
				}

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
				
				if (element is BzThinker)
				{
					_detectorT.removeBzThinker(element as BzThinker);
				}	
				else if (element is BzTerrain)
				{
					_detectorV.removeBzElement(element);
				}

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
			var needSort:Boolean = false;
			if (index >= 0)
			{
				if (element is BzThinker)
				{
					needSort = _detectorT.moveBzThinker(element as BzThinker);
				}	
				else if (element is BzTerrain)
				{
					needSort = _detectorV.moveBzElement(element);
				}

				if (needSort)
				{
					for each (var camera:BzCamera in _camera)
					{
						camera.sortPart(element);
					}
				}
			}
		}
		
		public	function getBzRectangle():BzRectangle
		{
			return _rect;
		}
		
		public	function getBzElements():Vector.<BzElement>
		{
			return _elements;
		}
		
		public	function getBzCameras():Vector.<BzCamera>
		{
			return _camera;
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
		
		public	function update(elapsed:Number = 1):void
		{
			_detectorT.update();
		}
		
		public	function render():void
		{
			for each (var camera:BzCamera in _camera)
			{
				camera.render();
			}
			_renderer.exec();
		}
		
		public	function getBzElementDetector():BzElementDetector
		{
			return _detectorV;
		}
		
		public	function getBzThinkerDetector():BzThinkerDetector
		{
			return _detectorT;
		}
	}
}