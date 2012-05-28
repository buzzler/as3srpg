package buzzler.core
{
	import buzzler.consts.BzTile;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.display.BzDisplayObject;
	import buzzler.data.display.BzElement;
	
	import flash.geom.Vector3D;

	/**
	 * BzScene의 장면을 Viewport에 2차원 평면 이미지로 변환을 위한 좌표변환을 담당한다.
	 * 더 나은 성능을 위해 BzViewport에 보여질 BzElement만 추출하는 역할을 한다.
	 * @author buzzler
	 */	
	public class BzCamera
	{
		private	var _rotation	:BzRotation;
		private	var _scene		:BzScene;
		private	var _viewport	:Vector.<BzViewport>;
		private	var _rect		:BzRectangle;
		private	var _reserved	:Boolean;
		private var _elements	:Vector.<BzElement>;
		private var _mulWidth	:Number;
		private	var _mulHeight	:Number;
		private	var _mulDepth	:Number;
		private	var _addX		:Number;
		private	var _addY		:Number;
		private	var _offsetX	:Number;
		private	var _offsetY	:Number;

		public	function BzCamera(rect:BzRectangle, look:BzRotation)
		{
			_rotation	= look.clone();
			_scene		= null;
			_viewport	= new Vector.<BzViewport>();
			_rect		= rect.clone();
			_reserved	= false;
			_elements	= new Vector.<BzElement>();
			_mulWidth	= BzTile.WIDTH / 2;
			_mulHeight	= BzTile.HEIGHT / 2;
			_mulDepth	= BzTile.DEPTH;
			
			updateOffset();
		}
		
		public	function setBzRotation(value:int):void
		{
			if (_rotation.getValue() != value)
			{
				_rotation.setValue(value);
				updateOffset(true, true);

				for each (var viewport:BzViewport in _viewport)
				{
					viewport.reserveProjectRotation();
					viewport.reserveSort();
				}
			}
		}
		
		public	function getBzRotation():BzRotation
		{
			return _rotation;
		}
		
		public	function setBzScene(scene:BzScene):void
		{
			_scene = scene;
		}
		
		public	function getBzScene():BzScene
		{
			return _scene;
		}
		
		public	function setOrigin(x:int, y:int, z:int):void
		{
			_rect.x = x;
			_rect.y = y;
			_rect.z = z;
			updateOffset();
			reserveUpdate();
		}
		
		public	function setBound(w:int, h:int, d:int):void
		{
			_rect.width = w;
			_rect.height = h;
			_rect.depth = d;
			updateOffset();
			reserveUpdate();
		}
		
		public	function contain(x:int, y:int, z:int):Boolean
		{
			return _rect.contains(x,y,z);
		}
		
		public	function containBzRectangle(rect:BzRectangle):Boolean
		{
			return _rect.containsBzRectangle(rect);
		}
		
		public	function addBzViewport(viewport:BzViewport):void
		{
			var index:int = _viewport.indexOf(viewport);
			if (index < 0)
			{
				_viewport.push(viewport);
				viewport.setBzCamera(this);
				viewport.reserveUpdate();
			}
		}
		
		public	function removeBzViewport(viewport:BzViewport):void
		{
			var index:int = _viewport.indexOf(viewport);
			if (index >= 0)
			{
				_viewport.splice(index, 1);
				viewport.setBzCamera(null);
				viewport.reserveUpdate();
			}
		}
		
		public	function sortPart(element:BzElement):void
		{
			for each (var viewport:BzViewport in _viewport)
			{
				viewport.reserveSortPart(element);
			}
		}
		
		public	function sort():void
		{
			for each (var viewport:BzViewport in _viewport)
			{
				viewport.reserveSort();
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
		
		public	function addBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index < 0)
			{
				_elements.push(element);
				
				for each (var viewport:BzViewport in _viewport)
				{
					viewport.reserveUpdate();
					viewport.reserveSort();
				}
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
			{
				_elements.splice(index, 1);
				
				for each (var viewport:BzViewport in _viewport)
				{
					viewport.reserveUpdate();
					viewport.reserveSort();
				}
			}
		}
		
		public	function reserveUpdate():void
		{
			_reserved = true;
		}
		
		public	function update():void
		{
			if (_reserved)
			{
				_elements.splice(0, _elements.length);
				var elements:Vector.<BzElement> = _scene.getBzElements();
				for each (var element:BzElement in elements)
				{
					if ( containBzRectangle(element.getBzRectangle()) )
					{
						_elements.push(element);
					}
				}
				_reserved = false;
				
				for each (var viewport:BzViewport in _viewport)
				{
					viewport.reserveUpdate();
				}
			}
		}
		
		public	function render():void
		{
			update();
			
			for each (var viewport:BzViewport in _viewport)
			{
				viewport.render();
			}
		}
		
		public	function unprojectRotation(rotation:Number):Number
		{
			switch (rotation)
			{
			case BzRotation.NORTH:
				return _rotation.getValue();
			case BzRotation.EAST:
				return int((_rotation.getValue()+90)%360);
			case BzRotation.SOUTH:
				return int((_rotation.getValue()+180)%360);
			case BzRotation.WEST:
				return int((_rotation.getValue()+270)%360);
			default:
				return rotation;
			}
		}
		
		public	function unprojectVector():Vector3D
		{
			switch (_rotation.getValue())
			{
			case BzRotation.NORTH:
				return new Vector3D(1,1,0);
			case BzRotation.SOUTH:
				return new Vector3D(-1,-1,0);
			case BzRotation.EAST:
				return new Vector3D(-1,1,0);
			case BzRotation.WEST:
				return new Vector3D(1,-1,0);
			default:
				return new Vector3D();
			}
		}
		
		public	function unprojectPosition(x:Number, y:Number):Vector3D
		{
			var A:Number = (x - BzTile.HALF_WIDTH - _offsetX) / _mulWidth;
			var B:Number = (y - _offsetY) / _mulHeight;
			
			var _x:Number = (A+B)/2;
			var _y:Number = (B-A)/2;
			var _z:Number = _rect.floor;
			
			switch (_rotation.getValue())
			{
				case BzRotation.NORTH:
					x = _x + _rect.x;
					y = _y + _rect.y;
					break;
				case BzRotation.SOUTH:
					x = _rect.width - _x + _rect.x;
					y = _rect.height - _y + _rect.y;
					break;
				case BzRotation.EAST:
					x = _rect.width - _y + _rect.x;
					y = _x + _rect.y;
					break;
				case BzRotation.WEST:
					x = _y + _rect.x;
					y = _rect.height - _x + _rect.y;
					break;
			}
			
			return new Vector3D( x, y, _z);
		}

		public	function projectPosition(tile:Vector3D, target:BzDisplayObject):void
		{
			var pos:Vector3D = new Vector3D();
			pos.z = tile.z - _rect.z;
			
			var rect:BzRectangle = target.getBzRectangle();
			switch (_rotation.getValue())
			{
				case BzRotation.NORTH:
					pos.x = tile.x - _rect.x;
					pos.y = tile.y - _rect.y;
					break;
				case BzRotation.SOUTH:
					if (target.getLocalRotation().getValue()%180 == 0)
					{
						pos.x = _addX - tile.x - rect.width + 1;
						pos.y = _addY - tile.y - rect.height + 1;
					}
					else
					{
						pos.x = _addX - tile.x - rect.height + 1;
						pos.y = _addY - tile.y - rect.width + 1;
					}
					break;
				case BzRotation.EAST:
					if (target.getLocalRotation().getValue()%180 != 0)
					{
						pos.x = tile.y - _rect.y;
						pos.y = _addY - tile.x - rect.height + 1;
					}
					else
					{
						pos.x = tile.y - _rect.y;
						pos.y = _addY - tile.x - rect.width + 1;
					}
					break;
				case BzRotation.WEST:
					if (target.getLocalRotation().getValue()%180 != 0)
					{
						pos.x = _addX - tile.y - rect.width + 1;
						pos.y = tile.x - _rect.x;
					}
					else
					{
						pos.x = _addX - tile.y - rect.height + 1;
						pos.y = tile.x - _rect.x;
					}
					break;
			}
			target.setLocalPosition(pos.x, pos.y, pos.z);
			
			target.x = (pos.x - pos.y) * _mulWidth + _offsetX;
			target.y = (pos.x + pos.y) * _mulHeight - pos.z * _mulDepth + _offsetY;
		}
		
		public	function projectRotation(rotation:BzRotation, target:BzDisplayObject):void
		{
			var angle:BzRotation = rotation.subtract(_rotation);
			target.setLocalRotation(angle.getValue());
			
			var size:Vector3D = target.getGlobalSize();
			if ( (angle.getValue()%180) == 0)
			{
				target.setLocalSize(size.x, size.y, size.z);
			}
			else
			{
				target.setLocalSize(size.y, size.x, size.z);
			}
		}
		
		private	function updateOffset(move:Boolean = true, rotate:Boolean = false):void
		{
			var bx:int;
			var by:int;
			var bz:int = _rect.depth;
			
			switch (_rotation.getValue())
			{
			case BzRotation.NORTH:
			case BzRotation.SOUTH:
				bx = _rect.width;
				by = _rect.height;
				break;
			case BzRotation.EAST:
			case BzRotation.WEST:
				bx = _rect.height;
				by = _rect.width;
				break;
			}
			
			_offsetX = (by - 1) * _mulWidth;
			_offsetY = (bz - 1) * _mulDepth;
			_addX = bx + _rect.x - 1;
			_addY = by + _rect.y - 1;
			
			for each (var viewport:BzViewport in _viewport)
			{
				if (move)
				{
					viewport.reserveProjectPosition();
				}
				if (rotate)
				{
					viewport.reserveProjectRotation();
				}
			}
		}
	}
}