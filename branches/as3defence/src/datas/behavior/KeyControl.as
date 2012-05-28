package datas.behavior
{
	import buzzler.core.BzCamera;
	import buzzler.data.BzRotation;
	import buzzler.data.behavior.IBzBehavior;
	import buzzler.data.display.BzMover;
	
	import controller.DataCenter;
	
	import flash.geom.Vector3D;
	
	public class KeyControl implements IBzBehavior
	{
		private	static var _instance:KeyControl
		public	static function getInstance():KeyControl
		{
			if (_instance == null)
				_instance = new KeyControl();
			return _instance;
		}
		
		public	static const SPEED_WALK		:Number = 0.1;
		
		public	static const VECTOR_UP		:Vector3D = new Vector3D(0,-1,0);
		public	static const VECTOR_DOWN	:Vector3D = new Vector3D(0,1,0);
		public	static const VECTOR_LEFT	:Vector3D = new Vector3D(-1,0,0);
		public	static const VECTOR_RIGHT	:Vector3D = new Vector3D(1,0,0);
		public	static const VECTOR_JUMP	:Vector3D = new Vector3D(0,0,0.1);
		
		public function get id():String
		{
			return "BzKeyControl";
		}
		
		public function calculate(mover:BzMover):Vector3D
		{
			var dcenter	:DataCenter	= DataCenter.getInstance();
			var camera	:BzCamera	= dcenter.level.camera;

			var result:Vector3D = new Vector3D();
			if (dcenter.key_up)
				result = result.add( VECTOR_UP );
			if (dcenter.key_down)
				result = result.add( VECTOR_DOWN );
			if (dcenter.key_left)
				result = result.add( VECTOR_LEFT );
			if (dcenter.key_right)
				result = result.add( VECTOR_RIGHT );
			
			result.normalize();
			result.scaleBy(SPEED_WALK);
			
			if (dcenter.key_space)
				result = result.add( VECTOR_JUMP );

			return result;
		}
	}
}