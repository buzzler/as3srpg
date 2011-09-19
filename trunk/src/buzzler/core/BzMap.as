package buzzler.core
{
	import buzzler.data.BzElement;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class BzMap
	{
		public const MAX_ITERATIONS:uint = 2000;
		
		private	var _bound:Vector3D;
		
		private var _ori	:BzCell;
		private var _dest	:BzCell;
		private var _current:BzCell;

		private var _opened	:Vector.<BzCell>;
		private var _closed	:Vector.<BzCell>;
		private var _map	:Vector.<Vector.<Vector.<BzCell>>>;
		private	var	_hash	:Dictionary;
		
		public function BzMap(width:int, height:int, depth:int):void 
		{
			_hash = new Dictionary();
			_bound = new Vector3D(width, height, depth);
			_map = new Vector.<Vector.<Vector.<BzCell>>>(_bound.x, true);
			for (var x:int = 0; x < _bound.x; x++)
			{
				_map[x] = new Vector.<Vector.<BzCell>>(_bound.y, true);
				for (var y:int = 0; y < _bound.y; y++)
				{
					_map[x][y] = new Vector.<BzCell>(_bound.z, true);
					for (var z:int = 0 ; z < _bound.z ; z++)
					{
						_map[x][y][z] = new BzCell(this, x, y, z);
					}
				}
			}
			_opened	= new Vector.<BzCell>();
			_closed	= new Vector.<BzCell>();
		}
		
		public function clear():void
		{
			for each (var y:Vector.<Vector.<BzCell>> in _map)
			{
				for each (var z:Vector.<BzCell> in y)
				{
					for each (var cell:BzCell in z)
					{
						cell.clear();
					}
				}
			}
		}
		
		public	function contain(rect:BzRectangle):Boolean
		{
			if (rect.lefti>=0 && rect.topi>=0 && rect.floori>=0 && 
				rect.righti<_bound.x && rect.bottomi<_bound.y && rect.ceili<_bound.z)
				return true;
			return false;
		}
		
		public	function addBzElement(element:BzElement):void
		{
			var rect:BzRectangle = element.getBzRectangle();
			if (contain(rect))
			{
				var cells:Vector.<BzCell> = new Vector.<BzCell>();
				for (var i:int = rect.lefti ; i <= rect.righti ; i++)
				{
					for (var j:int = rect.topi ; j <= rect.bottomi ; j++)
					{
						for (var k:int = rect.floori ; k <= rect.ceili ; k++)
						{
							_map[i][j][k].addBzElement(element);
							cells.push(_map[i][j][k]);
						}
					}
				}
				_hash[element] = cells;
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var cells:Vector.<BzCell> = _hash[element] as Vector.<BzCell>;
			if (cells)
			{
				for each (var cell:BzCell in cells)
				{
					cell.removeBzElement(element);
				}
				delete _hash[element];
			}
		}
		
		public	function moveBzElement(element:BzElement):Boolean
		{
			var rect:BzRectangle = element.getBzRectangle();
			var cells:Vector.<BzCell> = _hash[element] as Vector.<BzCell>;
			var startCell:BzCell = getBzCell(rect.lefti, rect.topi, rect.floori);
			var endCell:BzCell = getBzCell(rect.righti, rect.bottomi, rect.ceili);

			if (cells && startCell && endCell && (cells[0]!=startCell || cells[cells.length-1]!=endCell))
			{
				removeBzElement(element);
				addBzElement(element);
				return true;
			}
			return false;
		}
		
		public	function whichBzCell(element:BzElement):Vector.<BzCell>
		{
			return _hash[element] as Vector.<BzCell>;
		}
		
		public	function getBzCell(x:int, y:int, z:int):BzCell
		{
			if (x>=0 && y>=0 && z>=0 && x<_bound.x && y<_bound.y && z<_bound.z)
				return _map[x][y][z];
			return null;
		}
		
		public function getPath(origin:Vector3D, dest:Vector3D):Vector.<BzCell>
		{
			for each (var y:Vector.<Vector.<BzCell>> in _map)
			{
				for each (var z:Vector.<BzCell> in y)
				{
					for each (var cell:BzCell in z)
					{
						cell.reset();
					}
				}
			}
			_ori	= _map[origin.x][origin.y][origin.z];
			_dest	= _map[dest.x][dest.y][dest.z];
			_current= _ori;
			
			_opened.splice(0, _opened.length);
			_closed.splice(0, _closed.length);
			_closed.push(_ori);

			var solved:Boolean;
			var count:int = 0;
			do
			{
				solved = next();
				if(count++ > MAX_ITERATIONS)
					return null;
			} while (!solved);


			var solutionPath:Vector.<BzCell> = new Vector.<BzCell>();
			count = 0;
			var cellPointer:BzCell = _closed[_closed.length - 1];
			while(cellPointer != _ori)
			{
				if(count++ > MAX_ITERATIONS)
					return null;
				solutionPath.unshift(cellPointer);
				cellPointer = cellPointer.getParent();					
			}
			return solutionPath;
		}

		private function next():Boolean
		{
			if(_current == _dest)
			{
				_closed.push(_dest);
				return true;
			}
			
			_opened.push(_current);	

			var adjacent:Vector.<BzCell> = new Vector.<BzCell>();
			var cell:BzCell;			
			
			for (var x:int = -1; x <= 1; x++)
			{
				for (var y:int = -1; y <= 1; y++)
				{
					if (x != 0 && y != 0)
						continue;
					
					for (var z:int = -1; z <= 1; z++)
					{
						if(x == 0 && y == 0 && z == 0)
							continue;
						
						var pos:Vector3D = _current.getPosition().clone();
						pos.x += x;
						pos.y += y;
						pos.z += z;
						
						if(pos.x >= 0 && pos.y >= 0 && pos.z >= 0 && pos.x < _bound.x && pos.y < _bound.y && pos.z < _bound.z)
						{
							cell = _map[pos.x][pos.y][pos.z];
							if(cell.isWalkable() && _closed.indexOf(cell) == -1)
							{
								adjacent.push(cell);
							}								
						}
					}
				}						
			}
						
			for (var i:int = 0; i < adjacent.length; i++)
			{
								
				var g:int = _current.g + 1;
				var h:int = Vector3D.distance(adjacent[i].getPosition(), _dest.getPosition());
				
				if (_opened.indexOf(adjacent[i]) == -1)
				{									
					adjacent[i].setParent(_current, g, g+h);
					_opened.push(adjacent[i]);
				}
				else
				{
					if(adjacent[i].g < _current.getParent().g)
					{
						_current.setParent(adjacent[i], adjacent[i].g+1, adjacent[i].g+h);
					}
				}
			}
				
			var index:int = _opened.indexOf(_current);
			_opened.splice(index, 1);
			_opened.sort( function (a:BzCell, b:BzCell):int
			{
				return b.f - a.f
			});
			_closed.push(_current);
			
			if (_opened.length == 0)
				return true;
			
			_current = _opened.pop();			
			return false;
		}
	}
}
	
