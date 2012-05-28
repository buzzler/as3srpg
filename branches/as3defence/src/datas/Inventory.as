package datas
{
	import controller.DataCenter;
	
	import datas.objects.UnitBase;
	
	import flash.utils.Dictionary;
	
	import mx.messaging.AbstractConsumer;

	public class Inventory
	{
		private	static const HEAD		:int = 0;
		private	static const BODY		:int = 1;
		private	static const ARMS		:int = 2;
		private	static const FEET		:int = 3;
		private	static const WEAPON		:int = 4;
		private	static const SHIELD		:int = 5;
		private	static const ACCESSORY	:int = 6;
		private	static const BUFF		:int = 7;
		
		private	var _dictionary	:Dictionary;
		private	var _bag		:Dictionary;
		private	var _buff		:Vector.<Item>;
		private	var _equipments	:Vector.<Item>;
		
		public function Inventory()
		{
			_dictionary	= new Dictionary();
			_bag		= new Dictionary();
			_buff		= new Vector.<Item>();
			_equipments	= new Vector.<Item>(7,true);
		}
		
		public	function get dictionary():Dictionary
		{
			return _dictionary;
		}
		
		public	function get bag():Dictionary
		{
			return _bag;
		}
		
		public	function get buff():Vector.<Item>
		{
			return _buff;
		}
		
		public	function get head():Item
		{
			return _equipments[HEAD];
		}
		
		public	function get body():Item
		{
			return _equipments[BODY];
		}
		
		public	function get arms():Item
		{
			return _equipments[ARMS];
		}
		
		public	function get feet():Item
		{
			return _equipments[FEET];
		}
		
		public	function get weapon():Item
		{
			return _equipments[WEAPON];
		}
		
		public	function get shield():Item
		{
			return _equipments[SHIELD];
		}
		
		public	function get accessory():Item
		{
			return _equipments[ACCESSORY];
		}
		
		public	function addToBag(item:Item, count:uint = 1):void
		{
			if (!item)
			{
				return;
			}
			
			var exist:uint = _dictionary[item];
			if (exist)
			{
				_dictionary[item] = exist + count;
			}
			else
			{
				_dictionary[item] = count;
			}
			
			exist = _bag[item];
			if (exist)
			{
				_bag[item] = exist + count;
			}
			else
			{
				_bag[item] = count;
			}
		}
		
		public	function removeFromBag(item:Item, count:uint = 1):void
		{
			if (!item)
			{
				return;
			}
			
			var exist:uint = _dictionary[item];
			if (exist)
			{
				_dictionary[item] = Math.max(exist - count, 0);
			}
			
			exist = _bag[item];
			if (exist)
			{
				_bag[item] = Math.max(exist - count, 0);
			}
		}
		
		public	function attach(item:Item):void
		{
			if (!item)
			{
				return;
			}
			
			var exist:uint = _bag[item];
			if (exist && (exist>0))
			{
				_bag[item] = exist-1;
				
				if (item.type==BUFF)
				{
					_buff.push(item);
				}
				else if (item.type<BUFF)
				{
					var equiped:Item = _equipments[item.type];
					_equipments[item.type] = item;
					if (equiped)
					{
						exist = _bag[equiped];
						if (exist)
						{
							_bag[equiped] = exist+1;
						}
						else
						{
							_bag[equiped] = 1;
						}
					}
				}
			}
		}
		
		public	function dettach(item:Item):void
		{
			if (!item)
			{
				return;
			}
			
			if (item.type<BUFF)
			{
				var equiped:Item = _equipments[item.type];
				if (equiped && (equiped==item))
				{
					_equipments[item.type] = null;
					var exist:uint = _bag[equiped];
					if (exist)
					{
						_bag[equiped] = exist+1;
					}
					else
					{
						_bag[equiped] = 1;
					}
				}
			}
		}
		
		public	function clearBuff():void
		{
			_buff.length = 0;
		}
		
		public	function getPerformanceInBuff():Performance
		{
			var result:Performance = new Performance();
			for each (var item:Item in _buff)
			{
				result = result.add(item.performance);
			}
			return result;
		}
		
		public	function getPerformanceInEquipments():Performance
		{
			var result:Performance = new Performance();
			for each (var item:Item in _equipments)
			{
				result = result.add(item.performance);
			}
			return result;
		}
		
		public	function getPerformance():Performance
		{
			var buff:Performance = getPerformanceInBuff();
			return buff.add( getPerformanceInEquipments() );
		}
		
		public	static function generateFromXML(xml:XML):Inventory
		{
			var collection:Collection = DataCenter.getInstance().collection;
			var result:Inventory = new Inventory();

			result._equipments[HEAD]	= collection.getItemById(xml.@head) as Item;
			result._equipments[BODY]	= collection.getItemById(xml.@body) as Item;
			result._equipments[ARMS]	= collection.getItemById(xml.@arms) as Item;
			result._equipments[FEET]	= collection.getItemById(xml.@feet) as Item;
			result._equipments[WEAPON]	= collection.getItemById(xml.@weapon) as Item;
			result._equipments[SHIELD]	= collection.getItemById(xml.@shield) as Item;
			result._equipments[ACCESSORY]=collection.getItemById(xml.@accessory) as Item;
			
			for each (var stock:XML in xml.STOCK)
			{
				result.addToBag( collection.getItemById(stock.@id) as Item, parseInt(stock.@count) );
			}
			
			return result;
		}
	}
}