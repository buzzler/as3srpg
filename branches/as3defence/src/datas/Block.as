package datas
{
	import buzzler.data.BzRectangle;
	import buzzler.data.BzSet;
	import buzzler.data.display.BzElement;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public class Block
	{
		public	static function generateFromXML(xml:XML):BzElement
		{
//			var BlockClass:Class = ApplicationDomain.currentDomain.getDefinition( "data.objects."+xml.@type.toString() ) as Class;
			var name:String = "datas.objects."+xml.@type.toString();
			var BlockClass:Class = getDefinitionByName( name ) as Class;
			var id:String= xml.@id;
			var posX:int = parseInt(xml.@x);
			var posY:int = parseInt(xml.@y);
			var posZ:int = parseInt(xml.@z);

			return new BlockClass(id, posX,posY,posZ) as BzElement;
		}
		
		public	static function generateFromBlock(block:BzElement):XML
		{
			var result:XML			= <BLOCK/>;
			var rect:BzRectangle	= block.getBzRectangle();
			result.@type	= (typeof block).toString();
			result.@id		= block.getId();
			result.@x		= rect.x;
			result.@y		= rect.y;
			result.@z		= rect.z;
			
			return result;
		}
	}
}