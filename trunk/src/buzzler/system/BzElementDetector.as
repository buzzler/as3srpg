package buzzler.system
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzElement;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class BzElementDetector
	{
		public const MAX_ITERATIONS:uint = 2000;
		
		private	var _bound:Vector3D;

		private	var _compare:Function;
		private var _ori	:BzVoxel;
		private var _dest	:BzVoxel;
		private var _current:BzVoxel;

		private var _opened	:Vector.<BzVoxel>;
		private var _closed	:Vector.<BzVoxel>;
		private var _map	:Vector.<Vector.<Vector.<BzVoxel>>>;
		private	var	_hash	:Dictionary;
		
		public function BzElementDetector(width:int, height:int, depth:int):void 
		{
			_hash = new Dictionary();
			_bound = new Vector3D(width, height, depth);
			_map = new Vector.<Vector.<Vector.<BzVoxel>>>(_bound.x, true);
			for (var x:int = 0; x < _bound.x; x++)
			{
				_map[x] = new Vector.<Vector.<BzVoxel>>(_bound.y, true);
				for (var y:int = 0; y < _bound.y; y++)
				{
					_map[x][y] = new Vector.<BzVoxel>(_bound.z, true);
					for (var z:int = 0 ; z < _bound.z ; z++)
					{
						_map[x][y][z] = new BzVoxel(this, x, y, z);
					}
				}
			}
			_opened	= new Vector.<BzVoxel>();
			_closed	= new Vector.<BzVoxel>();
		}
		
		public function clear():void
		{
			for each (var y:Vector.<Vector.<BzVoxel>> in _map)
			{
				for each (var z:Vector.<BzVoxel> in y)
				{
					for each (var cell:BzVoxel in z)
					{
						cell.clear();
					}
				}
			}
		}
		
		public	function contain(rect:BzRectangle):Boolean
		{
			if (rect.lefti>=0 && rect.topi>=0 && rect.floori>=0 && 
				rect.righti<=_bound.x && rect.bottomi<=_bound.y && rect.ceili<=_bound.z)
				return true;
			return false;
		}
		
		public	function addBzElement(element:BzElement):void
		{
			var rect:BzRectangle = element.getBzRectangle();
			if (contain(rect))
			{
				var cells:Vector.<BzVoxel> = new Vector.<BzVoxel>();
				for (var i:int = 0 ; i < rect.width ; i++)
				{
					for (var j:int = 0 ; j < rect.height ; j++)
					{
						for (var k:int = 0 ; k < rect.depth ; k++)
						{
							var voxel:BzVoxel = _map[rect.lefti+i][rect.topi+j][rect.floori+k];
							voxel.addBzElement(element);
							cells.push(voxel);
						}
					}
				}
				_hash[element] = cells;
			}
		}
		
		public	function removeBzElement(element:BzElement):void
		{
			var cells:Vector.<BzVoxel> = _hash[element] as Vector.<BzVoxel>;
			if (cells)
			{
				for each (var cell:BzVoxel in cells)
				{
					cell.removeBzElement(element);
				}
				delete _hash[element];
			}
		}
		
		public	function moveBzElement(element:BzElement):Boolean
		{
			var rect:BzRectangle = element.getBzRectangle();
			var cells:Vector.<BzVoxel> = _hash[element] as Vector.<BzVoxel>;
			var startCell:BzVoxel = getBzVoxel(rect.lefti, rect.topi, rect.floori);
			var endCell:BzVoxel = getBzVoxel(rect.righti, rect.bottomi, rect.ceili);

			if (cells && startCell && endCell && (cells[0]!=startCell || cells[cells.length-1]!=endCell))
			{
				removeBzElement(element);
				addBzElement(element);
				return true;
			}
			return false;
		}

		public	function whichBzVoxel(element:BzElement):Vector.<BzVoxel>
		{
			return _hash[element] as Vector.<BzVoxel>;
		}

		public	function getBzVoxel(x:int, y:int, z:int):BzVoxel
		{
			if (x>=0 && y>=0 && z>=0 && x<_bound.x && y<_bound.y && z<_bound.z)
				return _map[x][y][z];
			return null;
		}
		
		public	function getBzVoxels(rect:BzRectangle):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			
			var fromX:int = Math.max(rect.left,0);
			var fromY:int = Math.max(rect.top, 0);
			var fromZ:int = Math.max(rect.floor, 0);
			var toX:int = Math.min(rect.right, _bound.x-1);
			var toY:int = Math.min(rect.bottom, _bound.y-1);
			var toZ:int = Math.min(rect.ceil, _bound.z-1);

			for (var i:int = fromX ; i <= toX ; i++)
			{
				for (var j:int = fromY ; j <= toY ; j++)
				{
					for (var k:int = fromZ ; k <= toZ ; k++)
					{
						result.push( _map[i][j][k] );
					}
				}
			}
			return result;
		}
/*		
		public	function getBzVoxelCircle(x:int, y:int, z:int, radiusIn:Number, radiusOut:Number, height:Number):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var fromX:int = Math.max( Math.floor(x-radiusOut) , 0);
			var fromY:int = Math.max( Math.floor(y-radiusOut) , 0);
			var fromZ:int = Math.max( Math.floor(z-height/2) , 0);
			var toX:int = Math.min( Math.ceil(x+radiusOut) , _bound.x-1 );
			var toY:int = Math.min( Math.ceil(y+radiusOut) , _bound.y-1 );
			var toZ:int = Math.min( Math.ceil(z+height/2) , _bound.z-1 );
			var rIn:Number	= Math.pow(radiusIn, 2);
			var rOut:Number	= Math.pow(radiusOut, 2);
			
			for (var i:int = fromX ; i <= toX ; i++)
			{
				for (var j:int = fromY ; j <= toY ; j++)
				{
					var temp:Number = Math.pow(i-x,2)+Math.pow(j-y,2);
					if ((temp>=rIn) && (temp<=rOut))
					{
						for (var k:int = fromZ ; k <= toZ ; k++)
						{
							result.push( _map[i][j][z] );
						}
					}
				}
			}
			return result;
		}
		
		public	function getBzVoxelDiamond(x:int, y:int, z:int, radiusIn:Number, radiusOut:Number, height:Number):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var fromX:int = Math.max( Math.floor(x-radiusOut) , 0);
			var fromY:int = Math.max( Math.floor(y-radiusOut) , 0);
			var fromZ:int = Math.max( Math.floor(z-height/2) , 0);
			var toX:int = Math.min( Math.ceil(x+radiusOut) , _bound.x-1 );
			var toY:int = Math.min( Math.ceil(y+radiusOut) , _bound.y-1 );
			var toZ:int = Math.min( Math.ceil(z+height/2) , _bound.z-1 );
			
			for (var i:int = fromX ; i <= toX ; i++)
			{
				for (var j:int = fromY ; j <= toY ; j++)
				{
					var temp:Number = Math.abs(i-x)+Math.abs(j-y);
					if ((temp>=radiusIn) && (temp<=radiusOut))
					{
						for (var k:int = fromZ ; k <= toZ ; k++)
						{
							result.push( _map[i][j][z] );
						}
					}
				}
			}
			return result;
		}
		
		public	function getBzVoxelSphere(x:int, y:int, z:int, radiusIn:Number, radiusOut:Number):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var fromX:int = Math.max( Math.floor(x-radiusOut) , 0);
			var fromY:int = Math.max( Math.floor(y-radiusOut) , 0);
			var fromZ:int = Math.max( Math.floor(z-radiusOut) , 0);
			var toX:int = Math.min( Math.ceil(x+radiusOut) , _bound.x-1 );
			var toY:int = Math.min( Math.ceil(y+radiusOut) , _bound.y-1 );
			var toZ:int = Math.min( Math.ceil(z+radiusOut) , _bound.z-1 );
			var rIn:Number = Math.pow(radiusIn, 2);
			var rOut:Number = Math.pow(radiusOut, 2);
			
			for (var i:int = fromX ; i <= toX ; i++)
			{
				for (var j:int = fromY ; j <= toY ; j++)
				{
					for (var k:int = fromZ ; k <= toZ ; k++)
					{
						var temp:Number = Math.pow(i-x,2)+Math.pow(j-y,2)+Math.pow(k-z,2);
						if ((temp>=rIn) && (temp<=rOut))
						{
							result.push( _map[i][j][z] );
						}
					}
				}
			}
			return result;
		}

		public	function getBzVoxelOctahedron(x:int, y:int, z:int, radiusIn:Number, radiusOut:Number):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var fromX:int = Math.max( Math.floor(x-radiusOut) , 0);
			var fromY:int = Math.max( Math.floor(y-radiusOut) , 0);
			var fromZ:int = Math.max( Math.floor(z-radiusOut) , 0);
			var toX:int = Math.min( Math.ceil(x+radiusOut) , _bound.x-1 );
			var toY:int = Math.min( Math.ceil(y+radiusOut) , _bound.y-1 );
			var toZ:int = Math.min( Math.ceil(z+radiusOut) , _bound.z-1 );
			
			for (var i:int = fromX ; i <= toX ; i++)
			{
				for (var j:int = fromY ; j <= toY ; j++)
				{
					for (var k:int = fromZ ; k <= toZ ; k++)
					{
						var temp:Number = Math.abs(i-x)+Math.abs(j-y)+Math.abs(k-z);
						if ((temp>=radiusIn) && (temp<=radiusOut))
						{
							result.push( _map[i][j][z] );
						}
					}
				}
			}
			return result;
		}
		*/
		public	function getBzVoxelWalkable(x:int, y:int, z:int, radius:int, height:int):Vector.<BzVoxel>
		{
			var result:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var checklist:Dictionary = new Dictionary();
			
			checkWalkable(x, y, z, 0, radius, height, checklist);
			
			for (var key:Object in checklist)
			{
				var voxel:BzVoxel = key as BzVoxel;
				if (voxel.isWalkable())
				{
					result.push( voxel );
				}
			}
			return result;
		}
		
		private	function checkWalkable(x:int, y:int, z:int, step:int, radius:int, height:int, checklist:Dictionary):void
		{
			if (step>radius)
			{
				return;
			}
			var voxel:BzVoxel = getBzVoxel(x,y,z);
			if (voxel==null)
			{
				return;
			}
			
			if (checklist[voxel] && (checklist[voxel] <= step))
			{
				return;
			}
			
			checklist[voxel] = step;
			
			if (voxel.isWalkable())
			{
				for (var i:int = -1 ; i <= 1 ; i++)
				{
					for (var j:int = -1 ; j <= 1 ; j++)
					{
						if (i!=0 && j!=0)
						{
							continue;
						}
						
						for (var k:int = -height ; k <= height ; k++)
						{
							if (i==0 && j==0 && k==0)
							{
								continue;
							}
							
							checkWalkable(x+i, y+j, z+k, step+Math.abs(i)+Math.abs(j)+Math.abs(k), radius, height, checklist);
						}
					}
				}
			}
			else
			{
				return;
			}
		}
		
		public	function getPath(origin:Vector3D, dest:Vector3D, compare:Function):Vector.<BzVoxel>
		{
			for each (var y:Vector.<Vector.<BzVoxel>> in _map)
			{
				for each (var z:Vector.<BzVoxel> in y)
				{
					for each (var cell:BzVoxel in z)
					{
						cell.reset();
					}
				}
			}
			_compare= compare;
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


			var solutionPath:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			count = 0;
			var cellPointer:BzVoxel = _closed[_closed.length - 1];
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

			var adjacent:Vector.<BzVoxel> = new Vector.<BzVoxel>();
			var cell:BzVoxel;
			
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
							if(_compare(cell) && _closed.indexOf(cell)<0)
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
			_opened.sort( function (a:BzVoxel, b:BzVoxel):int
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
	
