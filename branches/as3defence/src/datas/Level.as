package datas
{
	import buzzler.core.BzCamera;
	import buzzler.core.BzScene;
	import buzzler.core.BzViewport;
	import buzzler.data.BzRectangle;
	import buzzler.data.BzRotation;
	import buzzler.data.display.BzElement;
	
	import datas.objects.UnitBase;
	
	import flash.utils.getDefinitionByName;
	
	import mx.core.Application;

	public class Level
	{
		public	var id		:String;
		public	var owner	:Profile;
		public	var units	:Collection;
		public	var offencer:Team;
		public	var defencer:Team;
		public	var scene	:BzScene;
		public	var camera	:BzCamera;
		public	var viewport:BzViewport;
		
		public	static function generateFromXML(xml:XML):Level
		{
			var xmlScene:XML 	= xml.SCENE[0] as XML;
			var xmlCamera:XML	= xml.CAMERA[0] as XML;
			
			var result:Level 	= new Level();
			result.id			= xml.@id.toString();
			result.owner		= Profile.generateFromXML( xml.PROFILE[0] as XML );
			result.units		= Collection.generateFromXMLList( xml.UNIT, UnitBase.generateFromXML );
			result.offencer		= Team.generateFromXMLList( xml.OFFENCER, result.units );
			result.defencer		= Team.generateFromXMLList( xml.DEFENCER, result.units );
			result.viewport		= new BzViewport();
			result.scene		= new BzScene( new BzRectangle(0,0,0, parseInt(xmlScene.@width), parseInt(xmlScene.@height), parseInt(xmlScene.@depth)) );
			result.camera		= new BzCamera	(
									new BzRectangle(parseInt(xmlCamera.@x), parseInt(xmlCamera.@y), parseInt(xmlCamera.@z),	parseInt(xmlCamera.@width), parseInt(xmlCamera.@height), parseInt(xmlCamera.@depth)),
									new BzRotation(BzRotation.NORTH) );
			for each (var block:XML in xml.BLOCK)
			{
				result.scene.addBzElement(Block.generateFromXML(block));
			}
			
			for each (var unit:UnitBase in result.units.getHashMap())
			{
				result.scene.addBzElement( unit );
			}
			
			result.scene.addBzCamera( result.camera );
			result.camera.addBzViewport( result.viewport );
			
			return result;
		}
		
		public	static function generateFromLevel(level:Level):XML
		{
			var result	:XML = <RESULT/>;
			var scene	:XML = <SCENE/>;
			var camera	:XML = <CAMERA/>;

			var s:BzScene	= level.scene;
			var c:BzCamera	= level.camera;

			result.@id		= level.id;
			scene.@width	= s.getBzRectangle().width;
			scene.@height	= s.getBzRectangle().height;
			scene.@depth	= s.getBzRectangle().depth;
			camera.@x		= c.getBzRectangle().x;
			camera.@y		= c.getBzRectangle().y;
			camera.@z		= c.getBzRectangle().z;
			camera.@width	= c.getBzRectangle().width;
			camera.@height	= c.getBzRectangle().height;
			camera.@depth	= c.getBzRectangle().depth;

			result.appendChild( Profile.generateFromProfile(level.owner) );
			result.appendChild(scene);
			result.appendChild(camera);
			for each (var element:BzElement in level.scene.getBzElements())
			{
				result.appendChild( Block.generateFromBlock(element) );
			}

			return result;
		}
	}
}