Class {
	#name : #SDSnapshotCall,
	#superclass : #SDCall,
	#instVars : [
		'description'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotCall class >> pattern [
	^ #( 'snaps' '*' )
]

{ #category : #accessing }
SDSnapshotCall >> basename [
	^ self storagePath / ($_ join: { self description project . self description version . self description name })
]

{ #category : #'as yet unclassified' }
SDSnapshotCall >> buildDescription [
	| desc segments |
	segments := request uri segments allButFirst .
	desc := NeoJSONObject new
		id: UUID new printString;
		project: segments first;
		version: segments second;
		name: segments third.
	desc timestamp ifNil: [ desc timestamp: DateAndTime now printString ].
	^ desc

]

{ #category : #public }
SDSnapshotCall >> delete [
	(self basename , #fuel) asFileReference delete.
	(self basename , #json) asFileReference delete.
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #accessing }
SDSnapshotCall >> description [
	^ description ifNil: [ 
		description := self buildDescription ].

]

{ #category : #public }
SDSnapshotCall >> get [
	| fuelFile |
	fuelFile := (self basename , #fuel) asFileReference .
	response := ZnResponse ok: ((ZnStreamingEntity 
		type: ZnMimeType applicationOctetStream length: fuelFile size)
			stream: fuelFile readStream binary). 
]

{ #category : #accessing }
SDSnapshotCall >> head [
	| snapshot |
	snapshot := self store hasSnapshotWithId: request uri pathSegments second.
		"project: request uri pathSegments second
		version: request uri pathSegments third
		signature: request uri pathSegments fourth".
	response := snapshot notNil
		ifTrue: [ 
			ZnResponse ok: (ZnStringEntity text: 'OK') ]
		ifFalse: [ 
			ZnResponse notFound: request uri ]
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot |
	snapshot := SDFileSnapshot new 
		id: request uri pathSegments second;
		className: (request headers at: 'SnapDump-className');
		selector: (request headers at: 'SnapDump-selector');
		exceptionClass: (request headers at: 'SnapDump-exceptionClass');
		bytes: request contents.
	self store store: snapshot.
	"(self basename , #fuel) asFileReference writeStream binary
		nextPutAll: request contents;
		close.
	(NeoJSONWriter on: (self basename , #json) asFileReference writeStream) 
		nextPut: self description."
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]
