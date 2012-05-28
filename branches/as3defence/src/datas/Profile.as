package datas
{
	public class Profile
	{
		public	var id			:String;
		public	var name		:String;
		public	var thumbnail	:String;
		public	var exp			:int;
		public	var level		:String;
		
		public	static function generateFromXML(xml:XML):Profile
		{
			var profile:Profile = new Profile();

			profile.id			= xml.@id.toString();
			profile.name		= xml.@name.toString();
			profile.thumbnail	= xml.@thumbnail.toString();
			profile.exp			= parseInt( xml.@exp.toString() );
			profile.level		= xml.@level.toString();
				
			return profile;
		}
		
		public	static function generateFromProfile(profile:Profile):XML
		{
			var result:XML = <PROFILE/>;
			
			result.@id			= profile.id;
			result.@name		= profile.name;
			result.@thumbnail	= profile.thumbnail;
			result.@exp			= profile.exp;
			result.@level		= profile.level;
			
			return result;
		}
	}
}