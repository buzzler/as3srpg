package datas
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzVoxel;
	import buzzler.system.BzElementDetector;
	import buzzler.system.BzThinkerDetector;
	
	import datas.objects.UnitBase;
	
	import flash.geom.Vector3D;

	public class Skill
	{
		public	static const METHOD_CIRCLE		:String = "circle";
		public	static const METHOD_DIAMOND		:String = "diamond";
		public	static const METHOD_SPHERE		:String = "sphere";
		public	static const METHOD_OCTAHEDRON	:String = "octahedron";
		
		private	var _id		:String;
		private	var _method	:String;
		private	var _min	:int;
		private	var _max	:int;
		private	var _height	:int;
		private	var _name	:String;
		private	var _desc	:String;
		private	var _motion	:String;
		
		public function Skill(id:String, method:String, min:int, max:int, height:int, name:String, description:String, motion:String)
		{
			_id		= id;
			_method	= method;
			_min	= min;
			_max	= max;
			_height	= height;
			_name	= name;
			_desc	= description;
			_motion	= motion;
		}
		
		public	function get id():String
		{
			return _id;
		}
		
		public	function get method():String
		{
			return _method;
		}
		
		public	function get minimum():int
		{
			return _min;
		}
		
		public	function get maximum():int
		{
			return _max;
		}
		
		public	function get height():int
		{
			return _height;
		}
		
		public	function get name():String
		{
			return _name;
		}
		
		public	function get description():String
		{
			return _desc;
		}
		
		public	function get motion():String
		{
			return _motion;
		}
		
		public	function getAvailableBzVoxels(unit:UnitBase, posBzVoxels:Vector.<BzVoxel>, unitBzVoxels:Vector.<BzVoxel>):void
		{
			var allBzVoxels:Vector.<BzVoxel>;
			switch (_method)
			{
			case METHOD_CIRCLE:
				allBzVoxels = getPositionCircle(unit, _min, _max, _height);
				break;
			case METHOD_DIAMOND:
				allBzVoxels = getPositionDiamond(unit, _min, _max, _height);
				break;
			case METHOD_OCTAHEDRON:
				allBzVoxels = getPositionOctanhedron(unit, _min, _max);
				break;
			case METHOD_SPHERE:
				allBzVoxels = getPositionSphere(unit, _min, _max);
				break;
			default:
				allBzVoxels = getPositionDiamond(unit, 1,1,1);
				break;
			}
			
			var td:BzThinkerDetector = unit.getBzScene().getBzThinkerDetector();
			for each (var voxel:BzVoxel in allBzVoxels)
			{
				var pos:Vector3D = voxel.getPosition();
				var v:BzVoxel = td.getBzVoxel(pos.x, pos.y, pos.z);
				if (v.isThroughable())
				{
					posBzVoxels.push(voxel);
				}
				else
				{
					unitBzVoxels.push(v);
				}
			}
		}
		
		private	static function getPositionCircle(unit:UnitBase, min:Number, max:Number, height:Number):Vector.<BzVoxel>
		{
			var vd:BzElementDetector= unit.getBzScene().getBzElementDetector();
			var posU:Vector3D		= unit.getPosition();
			var minSq:Number		= Math.pow(min,2);
			var maxSq:Number		= Math.pow(max,2);
			
			var func:Function = function (item:BzVoxel, index:int, array:Vector.<BzVoxel>):Boolean{
				var posV:Vector3D = item.getPosition();
				var temp:Number = Math.pow(posV.x-posU.x,2)+Math.pow(posV.y-posU.y,2);
				
				return (temp>=minSq && temp<=maxSq && item.isWalkable());
			};
			
			return vd.getBzVoxels(new BzRectangle(posU.x-max,posU.y-max,posU.z-height,max*2,max*2,height*2)).filter(func);
		}
		
		private	static function getPositionDiamond(unit:UnitBase, min:Number, max:Number, height:Number):Vector.<BzVoxel>
		{
			var vd:BzElementDetector= unit.getBzScene().getBzElementDetector();
			var posU:Vector3D		= unit.getPosition();
			
			var func:Function = function (item:BzVoxel, index:int, array:Vector.<BzVoxel>):Boolean{
				var posV:Vector3D = item.getPosition();
				var temp:Number = Math.abs(posV.x-posU.x)+Math.abs(posV.y-posU.y);
				
				return (temp>=min && temp<=max && item.isWalkable());
			};
			
			return vd.getBzVoxels(new BzRectangle(posU.x-max,posU.y-max,posU.z-height,max*2,max*2,height*2)).filter(func);
		}
		
		private	static function getPositionOctanhedron(unit:UnitBase, min:Number, max:Number):Vector.<BzVoxel>
		{
			var vd:BzElementDetector= unit.getBzScene().getBzElementDetector();
			var posU:Vector3D		= unit.getPosition();
			
			var func:Function = function (item:BzVoxel, index:int, array:Vector.<BzVoxel>):Boolean{
				var posV:Vector3D = item.getPosition();
				var temp:Number = Math.abs(posV.x-posU.x)+Math.abs(posV.y-posU.y)+Math.abs(posV.z-posU.z);
				
				return (temp>=min && temp<=max && item.isWalkable());
			};
			
			return vd.getBzVoxels(new BzRectangle(posU.x-max,posU.y-max,posU.z-max,max*2,max*2,max*2)).filter(func);
		}
		
		private	static function getPositionSphere(unit:UnitBase, min:Number, max:Number):Vector.<BzVoxel>
		{
			var vd:BzElementDetector= unit.getBzScene().getBzElementDetector();
			var posU:Vector3D		= unit.getPosition();
			var minSq:Number		= Math.pow(min,2);
			var maxSq:Number		= Math.pow(max,2);
			
			var func:Function = function (item:BzVoxel, index:int, array:Vector.<BzVoxel>):Boolean{
				var posV:Vector3D = item.getPosition();
				var temp:Number = Math.pow(posV.x-posU.x,2)+Math.pow(posV.y-posU.y,2)+Math.pow(posV.z-posU.z,2);
				
				return (temp>=minSq && temp<=maxSq && item.isWalkable());
			};
			
			return vd.getBzVoxels(new BzRectangle(posU.x-max,posU.y-max,posU.z-max,max*2,max*2,max*2)).filter(func);
		}
		
		public	static function generateFromXML(xml:XML):Skill
		{
			var result:Skill = new Skill(xml.@id, xml.@method, xml.@min, xml.@max, xml.@height, xml.NAME, xml.DESCRIPTION, xml.@motion);
			return result;
		}
	}
}