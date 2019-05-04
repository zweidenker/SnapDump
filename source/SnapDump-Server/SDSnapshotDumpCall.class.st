Class {
	#name : #SDSnapshotDumpCall,
	#superclass : #SDCall,
	#instVars : [
		'description'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotDumpCall class >> pattern [
	^ #( 'snapshots' '*' 'fuel' )
]

{ #category : #public }
SDSnapshotDumpCall >> get [
	| fuelFile contents |
	fuelFile := self store snapshotDumpWithId: request uri pathSegments second.
	contents := fuelFile contents.
	response := ZnResponse ok: ((ZnStreamingEntity 
		type: ZnMimeType applicationOctetStream length: contents size)
			stream: contents readStream binary). 
]
