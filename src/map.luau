local ClassNames_Hexagon_Map = {	
	HxObject = 'HxObject'::'HxObject',
		HxLocalEnum = 'HxLocalEnum'::'HxLocalEnum',
			HxEnum = 'HxEnum'::'HxEnum', -- Auto-Replicatable
	
		
		HxAbstractBase = 'HxAbstractBase'::'HxAbstractBase',
	
			HxAbstractProperty = 'HxAbstractProperty'::'HxAbstractProperty', 
				--[[
				Abstract class for all classes that should be used as a property of another class.
				Classes in this class cannot use their neighbours due to their specifys.
				]]
				HxSnapshot = 'HxSnapshot'::'HxSnapshot',
	
				HxShade = 'HxShade'::'HxShade',
	
				HxAbstractMetalink = 'HxAbstractMetalink'::'HxAbstractMetalink',
					HxMetalinkCreator = 'HxMetalinkNew'::'HxMetalinkNew',
	
				HxHooker = 'HxHooker'::'HxHooker',
	
				HxAbstractConnection = 'HxAbstractConnection' :: 'HxAbstractConnection',
					--n/a
				HxEvent = 'HxEvent'::'HxEvent',
					HxEventConnection = 'HxEventConnection'::'HxEventConnection',
					HxEventProperties = 'HxEventProperties'::'HxEventProperties',
	
			HxAbstractPrimetive = 'HxAbstractPrimetive'::'HxAbstractPrimetive',
				HxString = 'HxString'::'HxString',
					HxTranslationString = 'HxTranslationString'::'HxTranslationString',
	
				HxNumber = 'HxNumber'::'HxNumber',
					HxNumberModifier = 'HxNumberModifier'::'HxNumberModifier',
	
			HxInstance = 'HxInstance'::'HxInstance',
				HxInstanceProperties = 'HxInstanceProperties'::'HxInstanceProperties',
				
	
				HxAbstractDataTree = 'HxAbstractDataTree'::'HxAbstractDataTree', -- Auto-Replicatable.
					HxWorldStorage = 'HxWorldStorage'::'HxWorldStorage',
	
				HxAbstractParallel = 'HxAbstractParallel'::'HxAbstractParallel', 
					HxParallelWorker = 'HxParallelWorker'::'HxParallelWorker',
					HxParallelConstantWorker = 'HxParallelConstantWorker'::'HxParallelConstantWorker',

		HxAbstractECS = 'HxAbstractECS' :: 'HxAbstractECS',
			HxComponent = 'HxAbstractComponent'::'HxAbstractComponent',
				-- You should create your own components.
	
			HxEntity = 'HxEntity'::'HxEntity',
	
			HxSystem = 'HxAbstractSystem'::'HxAbstractSystem', 
				HxSystemIO = 'HxSystemIO'::'HxSystemIO',
	
			HxWorld = 'HxWorld'::'HxWorld',
				
}
return table.freeze(ClassNames_Hexagon_Map)