package datas
{
	public class Performance
	{
		public	var health		:Stat;
		public	var magic		:Stat;
		public	var experience	:Stat;
		public	var capacity	:Stat;
		
		public	var strength	:Stat;		// Increases attack power, also affects Striking type weapons skills and combos.
		public	var vitality	:Stat;		// Increases defense and 40% of your VIT is added to your spear's damage.
		public	var intellect	:Stat;		// Increases magic damage, and also helps increase the damage of Bow/great sword/katana combos.
		public	var spirit		:Stat;		// Increases Magic defense and Healing Magic potency.
		public	var dexterity	:Stat;		// Increases accuracy, and mainly affects Thrusting type weapon damage.
		public	var agillity	:Stat;		// Increases evasion(dodge), weapons parrying rate and shields Blocking rate. Also affects Slashing type weapons damage.
		
		public	function Performance(health:Stat=null,magic:Stat=null,experience:Stat=null,capacity:Stat=null,strength:Stat=null,vitality:Stat=null,intellect:Stat=null,spirit:Stat=null,dexterity:Stat=null,agillity:Stat=null)
		{
			this.health		= health		? health:new Stat();
			this.magic		= magic			? magic:new Stat();
			this.experience	= experience	? experience:new Stat();
			this.capacity	= capacity		? capacity:new Stat();
			
			this.strength	= strength		? strength:new Stat();
			this.vitality	= vitality		? vitality:new Stat();
			this.intellect	= intellect		? intellect:new Stat();
			this.spirit		= spirit		? spirit:new Stat();
			this.dexterity	= dexterity		? dexterity:new Stat();
			this.agillity	= agillity		? agillity:new Stat();
		}
		
		public	function clone():Performance
		{
			return new Performance(health.clone(), magic.clone(), experience.clone(), capacity.clone(), strength.clone(), vitality.clone(), intellect.clone(), spirit.clone(), dexterity.clone(), agillity.clone());
		}

		public	function add(performance:Performance):Performance
		{
			var h:Stat = health.add(performance.health);
			var m:Stat = magic.add(performance.magic);
			var e:Stat = experience.add(performance.experience);
			var c:Stat = capacity.add(performance.capacity);
			var s:Stat = strength.add(performance.strength);
			var v:Stat = vitality.add(performance.vitality);
			var i:Stat = intellect.add(performance.intellect);
			var p:Stat = spirit.add(performance.spirit);
			var d:Stat = dexterity.add(performance.dexterity);
			var a:Stat = agillity.add(performance.agillity);
			
			return new Performance(h,m,e,c,s,v,i,p,d,a);
		}
		
		public	function subtract(performance:Performance):Performance
		{
			var h:Stat = health.subtract(performance.health);
			var m:Stat = magic.subtract(performance.magic);
			var e:Stat = experience.subtract(performance.experience);
			var c:Stat = capacity.subtract(performance.capacity);
			var s:Stat = strength.subtract(performance.strength);
			var v:Stat = vitality.subtract(performance.vitality);
			var i:Stat = intellect.subtract(performance.intellect);
			var p:Stat = spirit.subtract(performance.spirit);
			var d:Stat = dexterity.subtract(performance.dexterity);
			var a:Stat = agillity.subtract(performance.agillity);
			
			return new Performance(h,m,e,c,s,v,i,p,d,a);
		}
		
		public	function multiply(performance:Performance):Performance
		{
			var h:Stat = health.multiply(performance.health);
			var m:Stat = magic.multiply(performance.magic);
			var e:Stat = experience.multiply(performance.experience);
			var c:Stat = capacity.multiply(performance.capacity);
			var s:Stat = strength.multiply(performance.strength);
			var v:Stat = vitality.multiply(performance.vitality);
			var i:Stat = intellect.multiply(performance.intellect);
			var p:Stat = spirit.multiply(performance.spirit);
			var d:Stat = dexterity.multiply(performance.dexterity);
			var a:Stat = agillity.multiply(performance.agillity);
			
			return new Performance(h,m,e,c,s,v,i,p,d,a);
		}
		
		public	function divide(performance:Performance):Performance
		{
			var h:Stat = health.divide(performance.health);
			var m:Stat = magic.divide(performance.magic);
			var e:Stat = experience.divide(performance.experience);
			var c:Stat = capacity.divide(performance.capacity);
			var s:Stat = strength.divide(performance.strength);
			var v:Stat = vitality.divide(performance.vitality);
			var i:Stat = intellect.divide(performance.intellect);
			var p:Stat = spirit.divide(performance.spirit);
			var d:Stat = dexterity.divide(performance.dexterity);
			var a:Stat = agillity.divide(performance.agillity);
			
			return new Performance(h,m,e,c,s,v,i,p,d,a);
		}
		
		public	static function generateByXML(source:XML):Performance
		{
			var h:Stat = Stat.generateByXML(source.HEALTH[0]);
			var m:Stat = Stat.generateByXML(source.MAGIC[0]);
			var e:Stat = Stat.generateByXML(source.EXPERIENCE[0]);
			var c:Stat = Stat.generateByXML(source.CAPACITY[0]);
			var s:Stat = Stat.generateByXML(source.STRENGTH[0]);
			var v:Stat = Stat.generateByXML(source.VITALITY[0]);
			var i:Stat = Stat.generateByXML(source.INTELLECT[0]);
			var p:Stat = Stat.generateByXML(source.SPIRIT[0]);
			var d:Stat = Stat.generateByXML(source.DEXTERITY[0]);
			var a:Stat = Stat.generateByXML(source.AGILLITY[0]);
			
			return new Performance(h,m,e,c,s,v,i,p,d,a);
		}
	}
}