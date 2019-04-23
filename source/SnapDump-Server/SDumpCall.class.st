Class {
	#name : #SDumpCall,
	#superclass : #SnapDumpCall,
	#instVars : [
		'description'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDumpCall class >> pattern [
	^ #( 'snaps' '*' '*' '*' )
]

{ #category : #accessing }
SDumpCall >> basename [
	^ self storagePath / ($_ join: { self description project . self description version . self description name })
]

{ #category : #'as yet unclassified' }
SDumpCall >> buildDescription [
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
SDumpCall >> delete [
	(self basename , #fuel) asFileReference delete.
	(self basename , #json) asFileReference delete.
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #accessing }
SDumpCall >> description [
	^ description ifNil: [ 
		description := self buildDescription ].

]

{ #category : #public }
SDumpCall >> get [
	| fuelFile |
	fuelFile := (self basename , #fuel) asFileReference .
	response := ZnResponse ok: ((ZnStreamingEntity 
		type: ZnMimeType applicationOctetStream length: fuelFile size)
			stream: fuelFile readStream binary). 
]

{ #category : #accessing }
SDumpCall >> head [
	response := (self basename , #json) exists 
		ifTrue: [ 
			ZnResponse ok: (ZnStringEntity text: 'OK') ]
		ifFalse: [ 
			ZnResponse notFound: request uri ]
]

{ #category : #public }
SDumpCall >> put [
	(self basename , #fuel) asFileReference writeStream binary
		nextPutAll: request contents;
		close.
	(NeoJSONWriter on: (self basename , #json) asFileReference writeStream) 
		nextPut: self description.
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]
