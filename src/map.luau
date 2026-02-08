local ClassNames_Hexagon_Map = {	
	HxObject = 'HxObject'::'HxObject',
		HxLocalEnum = 'HxLocalEnum'::'HxLocalEnum',
			HxEnum = 'HxEnum'::'HxEnum', -- Auto-Replicatable
	
		
		HxBase = 'HxBase'::'HxBase',
	
			HxBaseProperty = 'HxBaseProperty'::'HxBaseProperty', 
				HxSnapshot = 'HxSnapshot'::'HxSnapshot',
				HxShade = 'HxShade'::'HxShade',
	
				HxAbstractMetalink = 'HxAbstractMetalink'::'HxAbstractMetalink',
					HxMetalinkCreator = 'HxMetalinkNew'::'HxMetalinkNew',
	
				HxHooker = 'HxHooker'::'HxHooker',
				HxActionEmmiter = 'HxActionEmmiter',
	
				HxAbstractConnection = 'HxAbstractConnection' :: 'HxAbstractConnection',
					IHxSelfConnection = 'HxSelfConnection' :: 'HxSelfConnection',
						HxReferencedConnection = 'HxReferencedConnection' :: 'HxReferencedConnection',
					IHxClassConnection = 'HxBaseDisconnectableConnection',
						HxConnection = 'HxConnection' :: 'HxConnection',
							HxConnectionController = 'HxConnectionController' :: 'HxConnectionController',
	
				HxEvent = 'HxEvent'::'HxEvent',
					HxEventConnection = 'HxEventConnection'::'HxEventConnection',
					HxEventProperties = 'HxEventProperties'::'HxEventProperties',
	
			HxAbstractPrimetive = 'HxAbstractPrimetive'::'HxAbstractPrimetive',
				HxString = 'HxString'::'HxString',
					HxTranslationString = 'HxTranslationString'::'HxTranslationString',
	
				HxNumber = 'HxNumber'::'HxNumber',
					HxNumberModifier = 'HxNumberModifier'::'HxNumberModifier',
	
				HxAbstractTable = 'HxAbstractTable'::'HxAbstractTable',
					HxNode = 'HxNode'::'HxNode',
	
	
					IHxArray = 'IHxArray'::'IHxArray',
						HxArray = 'HxArray'::'HxArray',
						HxWeakArray = 'HxWeakArray'::'HxWeakArray',
	
					IHxCollection = 'IHxCollection'::'IHxCollection',
						HxCollection = 'HxCollection'::'HxCollection',
						HxWeakCollection = 'HxWeakCollection'::'HxWeakCollection',
	
	
			HxInstance = 'HxInstance'::'HxInstance',
				HxInstanceProperties = 'HxInstanceProperties'::'HxInstanceProperties',
				
	
				HxAbstractDataTree = 'HxAbstractDataTree'::'HxAbstractDataTree', -- Auto-Replicatable.
					HxWorldStorage = 'HxWorldStorage'::'HxWorldStorage',
	
				HxBaseParallel = 'HxBaseParallel'::'HxBaseParallel', 
					HxParallelWorker = 'HxParallelWorker'::'HxParallelWorker',
					HxParallelConstantWorker = 'HxParallelConstantWorker'::'HxParallelConstantWorker',

		EcsBase = 'EcsBase' :: 'EcsBase',
			EcsComponent = 'EcsComponent'::'EcsComponent',
	
			EcsEntity = 'EcsEntity'::'EcsEntity',
	
			EcsBaseSystem = 'EcsBaseSystem'::'EcsBaseSystem',
				EcsSystem = 'EcsSystem'::'EcsSystem', 
				EcsSystemIO = 'EcsSystemIO'::'EcsSystemIO',
	
			EcsWorld = 'EcsWorld'::'EcsWorld',
				
}
return table.freeze(ClassNames_Hexagon_Map)