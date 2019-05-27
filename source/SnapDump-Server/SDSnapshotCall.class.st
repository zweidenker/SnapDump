Class {
	#name : #SDSnapshotCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'snapshotId'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotCall class >> parameterSnapshotId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'snapshotId';
		in: #path;
		beString;
		required: true;
		description: 'Snapshot with unique id'

]

{ #category : #accessing }
SDSnapshotCall class >> path [
	^ '/snapshots/{snapshotId}'
]

{ #category : #'submorphs-add/remove' }
SDSnapshotCall >> delete [
	[self store removeSnapshotWithId: snapshotId]
		on: FileDoesNotExistException 
		do: [ :err | ^ response := ZnResponse notFound: request uri ] .
	response := ZnResponse ok: (ZnStringEntity text: 'OK') 
]

{ #category : #public }
SDSnapshotCall >> get [
	| fuelFile json |
	json := true.
	fuelFile := self store snapshotWithId: snapshotId.
	request headers 
		at: 'Accept'
		ifPresent: [ :header | 
			(header = 'application/X-SnapDump-Fuel')
				ifTrue: [ json := false ] ].
	json 
		ifTrue: [ 
			self jsonResponse: fuelFile ]
		ifFalse: [ 
			response := ZnResponse ok: ((ZnStreamingEntity 
				type: ZnMimeType applicationOctetStream length: fuelFile fileSize)
				stream: fuelFile contentStream ) ] 
]

{ #category : #accessing }
SDSnapshotCall >> head [
	response := (self store hasSnapshotNamed: snapshotId)
		ifTrue: [ ZnResponse ok: (ZnStringEntity text: 'OK') ]
		ifFalse: [ ZnResponse notFound: request uri ]
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot |
	[snapshot := self store buildSnapshotFrom: request contents readStream.
	snapshot validate]
	on: ZnCharacterEncodingError  
	do: [:err | 
		^ response := ZnResponse 
			badRequest: request 
			entity: (ZnStringEntity text: err description) ].
	self store storeRaw: snapshot contents: request contents.
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]
