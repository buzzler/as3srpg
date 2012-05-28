package buzzler.core
{
	import buzzler.consts.BzTile;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzDisplayObject;
	import buzzler.data.display.BzElement;
	import buzzler.data.display.BzThinker;
	import buzzler.system.BzThinkerDetector;
	import buzzler.system.BzElementDetector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class BzViewport extends Sprite
	{
		private	var _camera				:BzCamera;
		private	var _thinkers			:Vector.<BzDisplayObject>;
		private	var _views				:Vector.<BzDisplayObject>;
		private	var _sort_views			:Vector.<BzDisplayObject>;
		
		private	var _reserve_update		:Boolean;
		private var _reserve_position	:Boolean;
		private var _reserve_rotation	:Boolean;
		private var _reserve_state		:Boolean;
		private	var _reserve_sort		:Boolean;
		private	var _reserve_sort_part	:Boolean;
		
		/**
		 * temporary variables for sort
		 */		
		private var _behinds:Dictionary;
		private var _depth	:uint;
		private var _visit	:Dictionary;


		public	function BzViewport()
		{
			super();
			
			_thinkers	= new Vector.<BzDisplayObject>();
			_views		= new Vector.<BzDisplayObject>();
			_sort_views	= new Vector.<BzDisplayObject>();
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

			if (_reserve_sort_part)
			{
				sortPart();
			}
			
			if (_reserve_sort)
			{
				sort();
			}
			
			_reserve_position	= false;
			_reserve_rotation	= false;
			_reserve_state		= false;
			_reserve_sort_part	= false;
			_reserve_sort		= false;
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
				var thinkers:Vector.<BzDisplayObject> = new Vector.<BzDisplayObject>();

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
					if (view.getBzElement() is BzThinker)
					{
						thinkers.push(view);
					}
				}
				
				for each (view in _views)
				{
					element = view.getBzElement();
					element.deleteBzDisplayObject(element);
					removeChild(view);
				}
				
				_views = views;
				_thinkers = thinkers;
				
				_reserve_update = false;
				reserveSort();
			}
		}
		
		public	function reserveSortPart(element:BzElement):void
		{
			_reserve_sort_part = true;
			_sort_views.push(element.generateBzDisplayObject(this));
		}
		
		public	function sortPart():void
		{
			var element:BzElement;
			var scene:BzScene				= _camera.getBzScene();
			var rect:BzRectangle			= _camera.getBzRectangle();
			var step:Vector3D				= _camera.unprojectVector();
			var detectorV:BzElementDetector	= scene.getBzElementDetector();
			
			for each (var view:BzDisplayObject in _sort_views)
			{
				var source	:BzElement	= view.getBzElement();
				var lt		:Vector3D	= _camera.unprojectPosition(view.realX, view.realY);
				var rt		:Vector3D	= _camera.unprojectPosition(view.realX+view.width, view.realY);
				var lb		:Vector3D	= _camera.unprojectPosition(view.realX, view.realY+view.height);
				var rb		:Vector3D	= _camera.unprojectPosition(view.realX+view.width, view.realY+view.height);
				
				var fromV	:Vector3D	= new Vector3D( Math.min(lt.x,rt.x,lb.x,rb.x), Math.min(lt.y,rt.y,lb.y,rb.y), lt.z);
				var toV		:Vector3D	= new Vector3D( Math.max(lt.x,rt.x,lb.x,rb.x), Math.max(lt.y,rt.y,lb.y,rb.y), rect.ceil-1);
				var clipped	:Dictionary	= new Dictionary();
				
				for (var k:int = fromV.z ; k < toV.z ; k++)
				{
					for (var j:int = fromV.y ; j < toV.y ; j++)
					{
						for (var i:int = fromV.x ; i < toV.x ; i++)
						{
							if (!_camera.contain(i,j,k))
							{
								continue;
							}
							
							var elements:Vector.<BzElement> = detectorV.getBzVoxel(i,j,k).getBzElements();
							
							for each (element in elements)
							{
								if (source != element)
								{
									clipped[element] = element;
								}
							}
						}
					}
					
					fromV = fromV.add(step);
					toV = toV.add(step);
				}
				
				var maxindex:int = 0;
				var rectA:BzRectangle = view.getBzRectangle();
				for each (element in clipped)
				{
					var dest:BzDisplayObject = element.generateBzDisplayObject(this);
					var rectB:BzRectangle = dest.getBzRectangle();
					
					if ( (rectA.mass==1) && (rectB.mass==1) && (source!=element) )
					{
						var ma:Number = Math.max(rectA.x, rectA.y);
						var mb:Number = Math.max(rectB.x, rectB.y);
						if (rectA.z > rectB.z)
						{
							maxindex = Math.max(getChildIndex(dest), maxindex);
						}
						else if (ma > mb)
						{
							maxindex = Math.max(getChildIndex(dest), maxindex);
						}
						else if (ma < mb)
						{
							continue;
						}
						else
						{
							var suma:Number = rectA.x + rectA.y;
							var sumb:Number = rectB.x + rectB.y;
							
							if (suma > sumb)
							{
								maxindex = Math.max(getChildIndex(dest), maxindex);
							}
							else if (suma < sumb)
							{
								continue;
							}
							else
							{
								if (rectA.z > rectB.z)
								{
									maxindex = Math.max(getChildIndex(dest), maxindex);
								}
								else if (rectA.z < rectB.z)
								{
									continue;
								}
							}
								
						}
						
					}
					else
					{
						if ( (rectB.lefti <= rectA.righti) && (rectB.topi <= rectA.bottomi) && (rectB.floori <= rectA.ceili) && (source != element) )
						{
							maxindex = Math.max(getChildIndex(dest), maxindex);
						}
					}
				}
				
				if (maxindex > getChildIndex(view))
				{
					setChildIndex(view, maxindex);
				}
				else
				{
					setChildIndex(view, maxindex+1);
				}
			}
			_sort_views.length = 0;
		}
		
		public	function reserveSort():void
		{
			_reserve_sort = true;
		}
		
		public	function sort(list:Vector.<BzDisplayObject> = null):void
		{
			_behinds = new Dictionary();
			_visit = new Dictionary();
		
			var targets:Vector.<BzDisplayObject> = (list) ? list:_views;
			
			for each (var viewA:BzDisplayObject in targets)
			{
				var behind:Vector.<BzDisplayObject> = new Vector.<BzDisplayObject>();
				var rectA:BzRectangle = viewA.getBzRectangle();
				for each (var viewB:BzDisplayObject in targets)
				{
					var rectB:BzRectangle = viewB.getBzRectangle();
					if ( (rectA.mass==1) && (rectB.mass==1) && (viewA!=viewB) )
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
			for each (var obj:BzDisplayObject in targets)
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