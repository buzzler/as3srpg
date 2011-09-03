package buzzler.core
{
	import buzzler.data.BzRotation;
	import buzzler.consts.BzTile;
	import buzzler.data.BzDisplayObject;
	import buzzler.data.BzElement;
	
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
		private	var _origin		:Vector3D;
		private	var _bound		:Vector3D;
		private	var _reserved	:Boolean;
		private var _elements	:Vector.<BzElement>;
		private var _mulWidth	:Number;
		private	var _mulHeight	:Number;
		private	var _mulDepth	:Number;
		private	var _addX		:Number;
		private	var _addY		:Number;
		private	var _offsetX	:Number;
		private	var _offsetY	:Number;

		public	function BzCamera(origin:Vector3D, bound:Vector3D, look:BzRotation)
		{
			_rotation	= look.clone();
			_scene		= null;
			_viewport	= new Vector.<BzViewport>();
			_origin		= origin.clone();
			_bound		= bound.clone();
			_reserved	= false;
			_elements	= new Vector.<BzElement>();
			_mulWidth	= BzTile.WIDTH / 2;
			_mulHeight	= BzTile.HEIGHT / 2;
			_mulDepth	= BzTile.DEPTH;
			
			updateOffset();
		}
		
		public	function setRotation(value:int):void
		{
			if (_rotation.getValue() != value)
			{
				_rotation.setValue(value);
				updateOffset(true, true);
			}
		}
		
		public	function getRotation():BzRotation
		{
			return _rotation;
		}
		
		public	function setBzScene(scene:BzScene):void
		{
			_scene = scene;
		}
		
		public	function setOrigin(x:int, y:int, z:int):void
		{
			_origin.x = x;
			_origin.y = y;
			_origin.z = z;
			updateOffset();
			reserveUpdate();
		}
		
		public	function setBound(w:int, h:int, d:int):void
		{
			_bound.x = w;
			_bound.y = h;
			_bound.z = d;
			updateOffset();
			reserveUpdate();
		}
		
		public	function contain(x:int, y:int, z:int):Boolean
		{
			if ( _origin.x>x || _origin.y>y || _origin.z>z )
			{
				return false;
			}
			else if ( _origin.x+_bound.x<=x || _origin.y+_bound.y<=y || _origin.z+_bound.z<=z )
			{
				return false;
			}
			else
			{
				return true;
			}
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
		
		public	function sort():void
		{
			for each (var viewport:BzViewport in _viewport)
			{
				viewport.sort();
			}
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
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
			{
				_elements.splice(index, 1);
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
					var pos:Vector3D = element.getPosition();
					if (contain(pos.x, pos.y, pos.z))
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
		
		public	function projectPosition(tile:Vector3D, target:BzDisplayObject):void
		{
			var pos:Vector3D = target.getLocalPosition();
			pos.z = tile.z - _origin.z;
			
			switch (_rotation.getValue())
			{
			case BzRotation.NORTH:
				pos.x = tile.x - _origin.x;
				pos.y = tile.y - _origin.y;
				break;
			case BzRotation.SOUTH:
				pos.x = _addX - tile.x;
				pos.y = _addY - tile.y;
				break;
			case BzRotation.EAST:
				pos.x = tile.y - _origin.y;
				pos.y = _addX - tile.x;
				break;
			case BzRotation.WEST:
				pos.x = _addY - tile.y;
				pos.y = tile.x - _origin.x;
				break;
			}
			
			target.x = (pos.x - pos.y) * _mulWidth + _offsetX;
			target.y = (pos.x + pos.y) * _mulHeight - pos.z * _mulDepth + _offsetY;
		}
		
		public	function projectRotation(rotation:BzRotation, target:BzDisplayObject):void
		{
			var result:BzRotation = rotation.subtract(_rotation);
			target.setLocalRotation(result.getValue());
		}
		
		private	function updateOffset(move:Boolean = true, rotate:Boolean = false):void
		{
			var bx:int;
			var by:int;
			var bz:int = _bound.z;
			
			switch (_rotation.getValue())
			{
			case BzRotation.NORTH:
			case BzRotation.SOUTH:
				bx = _bound.x;
				by = _bound.y;
				break;
			case BzRotation.EAST:
			case BzRotation.WEST:
				bx = _bound.y;
				by = _bound.x;
				break;
			}
			
			_offsetX = (by - 1) * _mulWidth;
			_offsetY = (bz - 1) * _mulDepth;
			_addX = bx + _origin.x - 1;
			_addY = by + _origin.y - 1;
			
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