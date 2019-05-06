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
		ifFalse: [ | fuel |
			
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
	snapshot := SDFileSnapshot new 
		id: request uri pathSegments second;
		project: (request headers at: 'SnapDump-project');
		version: (request headers at: 'SnapDump-version');
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
