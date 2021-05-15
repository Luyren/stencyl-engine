package com.stencyl.behavior;

import com.stencyl.utils.Utils;

class BehaviorManager
{
	public var behaviors:Array<Behavior>;

	public var cache:Map<String,Behavior>;

	//*-----------------------------------------------
	//* Init
	//*-----------------------------------------------
	
	public function new()
	{
		behaviors = new Array<Behavior>();
		cache = new Map<String,Behavior>();
	}
	
	public function destroy()
	{
		behaviors = null;
		cache = null;
	}
	
	//*-----------------------------------------------
	//* Ops
	//*-----------------------------------------------
	
	public function add(b:Behavior)
	{
		cache.set(b.name, b);
		behaviors.push(b);
	}
	
	public function hasBehavior(b:String):Bool
	{
		if(cache == null)
		{
			return false;
		}
		
		return cache.get(b) != null;
	}
	
	public function enableBehavior(b:String)
	{
		if(hasBehavior(b))
		{
			var bObj:Behavior = cache.get(b);
			
			if(bObj.script != null && !bObj.script.scriptInit)
			{
				try
				{
					bObj.script.init();
					bObj.script.scriptInit = true;
				}
			
				catch(e:String)
				{
					trace("Error in when created for behavior: " + bObj.name);
					trace(e + Utils.printExceptionstackIfAvailable());
				}
			}
			
			bObj.enabled = true;
		}
	}
	
	public function disableBehavior(b:String)
	{
		if(hasBehavior(b))
		{
			cache.get(b).enabled = false;
		}
	}
	
	public function isBehaviorEnabled(b:String):Bool
	{
		if(hasBehavior(b))
		{
			return cache.get(b).enabled;
		}
		
		return false;
	}
	
	//*-----------------------------------------------
	//* Events
	//*-----------------------------------------------
	
	public function initScripts()
	{
		for(i in 0...behaviors.length)
		{
			var b:Behavior = behaviors[i];
			b.initScript(!b.enabled);
		}	
	}
	
	//*-----------------------------------------------
	//* Messaging
	//*-----------------------------------------------
	
	public function getAttribute(behaviorName:String, attributeName:String):Dynamic
	{
		var b:Behavior = cache.get(behaviorName);
		
		if(b != null && b.script != null)
		{
			attributeName = b.script.toInternalName(attributeName);
			
			var field = Reflect.field(b.script, attributeName);

			if(field == null && !ReflectionHelper.hasField(b.script.wrapper.classname, attributeName))
			{
				trace("Get Warning: Attribute " + attributeName + " does not exist for " + behaviorName + Utils.printCallstackIfAvailable());
			}
			
			return field;
		}
		
		else
		{
			trace("Warning: Behavior does not exist - " + behaviorName + Utils.printCallstackIfAvailable());
		}
		
		return null;
	}
	
	public function setAttribute(behaviorName:String, attributeName:String, value:Dynamic)
	{
		var b:Behavior = cache.get(behaviorName);
		
		if(b != null && b.script != null)
		{
			if(ReflectionHelper.hasField(b.script.wrapper.classname, attributeName))
			{
				Reflect.setField(b.script, attributeName, value);
				b.script.propertyChanged(attributeName);
			}
			
			else
			{
				trace("Set Warning: Attribute " + attributeName + " does not exist for " + behaviorName + Utils.printCallstackIfAvailable());
			}
		}
		
		else
		{
			trace("Warning: Behavior does not exist - " + behaviorName + Utils.printCallstackIfAvailable());	
		}
	}

	public function call(msg:String, args:Array<Dynamic>):Dynamic
	{
		if(cache == null)
		{
			return null;
		}

		var toReturn:Dynamic = null;
		
		for(i in 0...behaviors.length)
		{
			var item:Behavior = behaviors[i];
			
			if(!item.enabled || item.script == null) 
			{
				continue;
			}
			
			//XXX: Flash works slightly differently from the rest on this... :(
			#if flash
			if(Reflect.hasField(item.script, msg))
			#else
			try
			#end
			{
				var f = Reflect.field(item.script, msg);
			
				if(f != null)
				{
					toReturn = Reflect.callMethod(item.script, f, args);
				}
				
				else
				{
					item.script.forwardMessage(msg);
				}
			}
			
			#if flash
			else
			#else
			catch(e:String)
			#end
			{
				item.script.forwardMessage(msg);
			}
		}
		
		return toReturn;
	}
	
	public function call2(behaviorName:String, msg:String, args:Array<Dynamic>):Dynamic
	{
		if(cache == null)
		{
			return null;
		}

		var toReturn:Dynamic = null;
		var item:Behavior = cache.get(behaviorName);
		
		if(item != null)
		{
			if(!item.enabled || item.script == null)
			{
				return toReturn;
			}
			
			//XXX: Flash works slightly differently from the rest on this... :(
			#if flash
			if(Reflect.hasField(item.script, msg))
			#else
			try
			#end
			{
				var f = Reflect.field(item.script, msg);
			
				if(f != null)
				{
					toReturn = Reflect.callMethod(item.script, f, args);
				}
				
				else
				{
					item.script.forwardMessage(msg);
				}
			}
			
			#if flash
			else
			#else
			catch(e:String)
			#end
			{
				item.script.forwardMessage(msg);
			}
		}

		return toReturn;
	}
}