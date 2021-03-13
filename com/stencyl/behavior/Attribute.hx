package com.stencyl.behavior;

import com.stencyl.models.GameModel;

class Attribute 
{	
	public var ID:Int;
	public var fieldName:String;
	public var fullName:String;
	public var type:String;
	
	public var defaultValue:String;
	public var value:Dynamic;
	
	public var realValue:Dynamic;
	public var parent:Dynamic;

	public var hidden:Bool;
	
	public function new(ID:Int, fieldName:String, fullName:String, value:Dynamic, type:String, parent:Dynamic, hidden:Bool)
	{
		this.ID = ID;
		this.fieldName = fieldName;
		this.fullName = fullName;
		this.type = type;

		this.value = value;
		realValue = null;
		
		this.hidden = hidden;
	}
	
	public function getRealValue():Dynamic
	{
		if(realValue == null)
		{
			if(type == "int")
			{
				realValue = value;
			}
			
			else if(type == "float" || type == "number")
			{
				realValue = value;
			}
			
			else if(type == "bool" || type == "boolean")
			{
				realValue = value;
			}
			
			else if(type == "color")
			{
				realValue = value;
			}
			
			else if(type == "sound" || type == "actortype" || type == "font")
			{
				if(value != null)
				{
					if(value == -1)
					{
						realValue = null;
					}
					
					else
					{
						realValue = Data.get().resources.get(value);
					}
					
					if(type == "font" && !Std.isOfType(realValue, com.stencyl.models.Font))
					{
						realValue = null;
					}
					
					if(type == "sound" && !Std.isOfType(realValue, com.stencyl.models.Sound))
					{
						realValue = null;
					}
					
					if(type == "actortype" && !Std.isOfType(realValue, com.stencyl.models.actor.ActorType))
					{
						realValue = null;
					}
				}
			}
			
			else if(type == "actorgroup")
			{
				//Script will pull the right group. Keep as int.
				realValue = value;
			}
			
			else if(type == "control")
			{
				realValue = value;
			}
			
			else if(type == "effect")
			{
				realValue = value;
			}
			
			else if(type == "animation")
			{
				realValue = value;
			}
			
			else if(type == "game-attribute")
			{
				realValue = value;
			}
			
			else if(type == "scene")
			{
				realValue = GameModel.get().scenes.get(value);
			}
			
			else if(type == "text") 
			{
				realValue = value;
			}
			
			else if(type == "list")
			{
				realValue = value;
				
				if(value == null || value == "")
				{
					realValue = new Array<Dynamic>();
				}	
			}
			
			else if (type == "map")
			{
				realValue = value;
				
				if (value == null || value == "")
				{
					realValue = new Map<String, Dynamic>();
				}
			}
			
			else if(value != null && type == "actor")
			{
				if(value == "thisactor")
				{
					realValue = parent;
				}
				
				else
				{
					realValue = Std.parseInt(value);
				}
			}
			
			else if(value != null && type == "joint")
			{
				realValue = value;
			}
			
			else if(value != null && type == "region")
			{
				realValue = value;
			}
		}
		
		return realValue;
	}
}
