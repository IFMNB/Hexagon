local ClassNames_Hexagon_Map = {	
	HxObject = 'HxObject'::'HxObject',
		HxSnapshot = 'HxSnapshot'::'HxSnapshot',
	
		INet = 'INet' :: 'INet',
			HxRuntimeException = 'HxRuntimeException'::'HxRuntimeException',
			HxLocalEnum = 'HxLocalEnum'::'HxLocalEnum',
	
		
		HxBase = 'HxBase'::'HxBase',
			HxConnection = 'HxConnection' :: 'HxConnection',
			HxEvent = 'HxEvent' :: 'HxEvent',
	
			IHxPrimetive = 'IHxPrimetive'::'IHxPrimetive',
				HxNumber = 'HxNumber'::'HxNumber',
				HxString = 'HxString'::'HxString',
				
	
	
			HxBaseCollection = 'HxBaseCollection'::'HxBaseCollection',
				HxNode = 'HxNode'::'HxNode',
					HxNodeList = 'HxList'::'HxList',

				IHxList = 'IHxList'::'IHxList',
					HxList = 'HxList'::'HxList',
					HxWeakList = 'HxWeakList'::'HxWeakList',

				IHxMap = 'IHxMap'::'IHxMap',
					HxMap = 'HxMap'::'HxMap',
					HxWeakMap = 'HxWeakMap'::'HxWeakMap',	
	
			IHxProperty = 'IHxProperty'::'IHxProperty',
				HxObjectManager = 'HxObjectManager'::'HxObjectManager',
				HxShade = 'HxShade'::'HxShade',
				
				HxAbstractMetalink = 'HxAbstractMetalink'::'HxAbstractMetalink',
					HxMetalinkCreator = 'HxMetalinkNew'::'HxMetalinkNew',
	
				HxHooker = 'HxHooker'::'HxHooker',
				HxActionEmmiter = 'HxActionEmmiter',
					HxSignal = 'HxSignal'::'HxSignal',
						HxEventCore = 'HxEventCore'::'HxEventCore',
	



				
}
return table.freeze(ClassNames_Hexagon_Map)