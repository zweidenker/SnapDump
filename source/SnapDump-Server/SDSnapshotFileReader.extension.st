Extension { #name : #SDSnapshotFileReader }

{ #category : #'*SnapDump-Server' }
SDSnapshotFileReader >> fuelDumpEntity [
	
	^ self fuelDumpStreamDo: [:str :length |
		ZnStreamingEntity 
			readFrom: str 
			usingType: (ZnMimeType main: 'application' sub: SDStore mimeTypeFuel) 
			andLength: length ].
]

{ #category : #'*SnapDump-Server' }
SDSnapshotFileReader >> stackTraceEntity [

	^ self stackTraceStreamDo: [:str :length |
		ZnStreamingEntity 
			readFrom: str 
			usingType: ZnMimeType textPlain 
			andLength: length ].
]
