package datas
{
	import flash.utils.Dictionary;

	public class EquipSlot
	{
		private	var	_single		:Boolean;
		private	var _items		:Vector.<Item>;
		private	var _counter	:Dictionary;
		private	var _performance:Performance;

		public	function EquipSlot(single:Boolean = false)
		{
			_single		= single;
			_items		= single ? new Vector.<Item>(1,true):new Vector.<Item>();
			_counter	= new Dictionary();
			_performance= new Performance(null, null, null, null, null, null, null, null, null, null);
		}
		
		public	function getItems():Vector.<Item>
		{
			return _items;
		}
		
		public	function getItemCount(item:Item):uint
		{
			var count:uint = 0;
			if (_counter[item])
			{
				count = _counter[item] as uint;
			}

			return count;
		}
		
		public	function getPerformance():Performance
		{
			return _performance;
		}

		public	function addItem(item:Item, count:uint = 1):Item
		{
			var exist:Item;
			if (_single)
			{
				exist = _items[0];
				delete _counter[item];
				
				_items[0] = item;
				_counter[item] = 1;
				_performance = item.performance;
			}
			else
			{
				exist = item;
				if (_items.indexOf(item) < 0)
				{
					_items.push(item);
					_counter[item] = 0;
				}
				_counter[item] += count;
				for (var i:int = 0 ; i < count ; i++)
				{
					_performance = _performance.add( item.performance );
				}
			}
			return exist;
		}
		
		public	function removeItem(item:Item, count:uint = 1):Item
		{
			if (_single)
			{
				if (_items[0] == item)
				{
					_items[0] = null;
					delete _counter[item];
					_performance = new Performance(null, null, null, null, null, null, null, null, null, null);
				}
			}
			else
			{
				var index:int = _items.indexOf(item);
				if (index >= 0)
				{
					var i:int;
					var exist:uint = _counter[item] as uint;
					if (exist > count)
					{
						_counter[item] = exist - count;
						for (i = 0 ; i < count ; i++)
						{
							_performance = _performance.subtract( item.performance );
						}
					}
					else
					{
						_items.splice(index, 1);
						delete _counter[item];
						for (i = 0 ; i < exist ; i++)
						{
							_performance = _performance.subtract( item.performance );
						}
					}
				}
			}
			return item;
		}
	}
}