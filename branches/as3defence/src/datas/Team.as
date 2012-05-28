package datas
{
	import datas.objects.UnitBase;

	public class Team
	{
		private	var _units		:Vector.<UnitBase>;
		private	var _mover		:Vector.<UnitBase>;
		private	var _attacker	:Vector.<UnitBase>;
		
		public function Team()
		{
			_units		= new Vector.<UnitBase>();
			_mover		= new Vector.<UnitBase>();
			_attacker	= new Vector.<UnitBase>();
		}
		
		public	function getUnits():Vector.<UnitBase>
		{
			return _units;
		}
		
		public	function addUnit(unit:UnitBase):void
		{
			if (!contain(unit))
			{
				_units.push(unit);
			}
		}
		
		public	function removeUnit(unit:UnitBase):void
		{
			if (contain(unit))
			{
				_units.splice( _units.indexOf(unit) ,1);
			}
		}

		public	function contain(unit:UnitBase):Boolean
		{
			return ( _units.indexOf(unit)>=0 );
		}
		
		public	function isMovableAll():Boolean
		{
			return ( _units.length!=_mover.length );
		}
		
		public	function isMovable(unit:UnitBase):Boolean
		{
			return ( _mover.indexOf(unit)<0 );
		}
		
		public	function isAttackableAll():Boolean
		{
			return ( _units.length!=_attacker.length );
		}
		
		public	function isAttackable(unit:UnitBase):Boolean
		{
			return ( _attacker.indexOf(unit)<0 );
		}
		
		public	function reset():void
		{
			_mover.length = 0;
			_attacker.length = 0;
		}
		
		public	function clearTouchFlag():void
		{
			for each (var unit:UnitBase in _units)
			{
				unit.clearTouchFlag();
			}
		}
		
		public	function moveUnit(unit:UnitBase):void
		{
			if (contain(unit) && isMovable(unit))
			{
				_mover.push(unit);
			}
		}
		
		public	function attackUnit(unit:UnitBase):void
		{
			if (contain(unit) && isAttackable(unit))
			{
				_attacker.push(unit);
			}
		}
		
		public	static function generateFromXMLList(xmllist:XMLList, collection:Collection):Team
		{
			var result:Team = new Team();
			for each (var xml:XML in xmllist)
			{
				result.addUnit( collection.getItemById(xml.@id) as UnitBase );
			}
			return result;
		}
	}
}