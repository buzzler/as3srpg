package datas.objects
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.BzVoxel;
	import buzzler.data.display.BzUnit;
	import buzzler.system.BzElementDetector;
	import buzzler.system.ai.IBzState;
	
	import datas.Collection;
	import datas.Inventory;
	import datas.Performance;
	import datas.Skill;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class UnitBase extends BzUnit
	{
		public	var inventory:Inventory;
		public	var performance:Performance;
		public	var skill:Collection;

		public function UnitBase(id:String, sets:BzSet, state:String, aabb:BzRectangle, think:IBzState, thinkGlobal:IBzState=null)
		{
			super(id, sets, state, aabb, think, thinkGlobal);
		}
		
		public	function takeAffection(skill:Skill, opponent:UnitBase):void
		{
			;
		}
		
		public	function giveAffection(skill:Skill, opponent:UnitBase):void
		{
			;
		}
		
		public	static function generateFromXML(xml:XML):UnitBase
		{
			var name:String = "datas.objects."+xml.@type.toString();
			var UnitClass:Class = getDefinitionByName( name ) as Class;
			var id:String= xml.@id;
			var posX:int = parseInt(xml.@x);
			var posY:int = parseInt(xml.@y);
			var posZ:int = parseInt(xml.@z);
			
			var inventory:Inventory = Inventory.generateFromXML(xml.INVENTORY[0]);
			var performance:Performance = Performance.generateByXML(xml.PERFORMANCE[0]);
			var skill:Collection = Collection.generateFromXMLList(xml.SKILL, Skill.generateFromXML);
			
			var result:UnitBase	= new UnitClass(id, posX,posY,posZ) as UnitBase;
			result.inventory	= inventory;
			result.performance	= performance;
			result.skill		= skill;
			return result;
		}

		public	function getMovablePositions():Vector.<BzVoxel>
		{
			var vd:BzElementDetector = this.getBzScene().getBzElementDetector();
			var pos:Vector3D = this.getPosition();
			
			return vd.getBzVoxelWalkable(pos.x, pos.y, pos.z, 8, 1);
		}
	}
}