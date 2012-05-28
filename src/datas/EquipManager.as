package datas
{
	public class EquipManager
	{
		private	var _buff		:EquipSlot;
		private	var _head		:EquipSlot;
		private	var _body		:EquipSlot;
		private	var _arms		:EquipSlot;
		private	var _feet		:EquipSlot;
		private	var _left		:EquipSlot;
		private	var _right		:EquipSlot;
		private	var _accessory	:EquipSlot;
		private	var _inventory	:EquipSlot;
		
		public function EquipManager()
		{
			_buff		= new EquipSlot();
			_head		= new EquipSlot(true);
			_body		= new EquipSlot(true);
			_arms		= new EquipSlot(true);
			_feet		= new EquipSlot(true);
			_left		= new EquipSlot(true);
			_right		= new EquipSlot(true);
			_accessory	= new EquipSlot(true);
			_inventory	= new EquipSlot();
		}
		
		public	function get buff()		:EquipSlot	{return _buff;}
		public	function get head()		:EquipSlot	{return _head;}
		public	function get body()		:EquipSlot	{return _body;}
		public	function get arms()		:EquipSlot	{return _arms;}
		public	function get feet()		:EquipSlot	{return _feet;}
		public	function get left()		:EquipSlot	{return _left;}
		public	function get right()	:EquipSlot	{return _right;}
		public	function get accessory():EquipSlot	{return _accessory;}
		public	function get inventory():EquipSlot	{return _inventory;}
		
		public	function getPerformance(includeInventory:Boolean = false):Performance
		{
			var result:Performance = _buff.getPerformance().add(_head.getPerformance());
			result = result.add( _body.getPerformance() );
			result = result.add( _arms.getPerformance() );
			result = result.add( _feet.getPerformance() );
			result = result.add( _left.getPerformance() );
			result = result.add( _right.getPerformance() );
			result = result.add( _accessory.getPerformance() );
			return includeInventory ? result.add(_inventory.getPerformance()):result;
		}

		public	function attach(item:Item):Item
		{
			return null;
		}
		
		public	function dettach(item:Item):Item
		{
			return null;
		}
	}
}