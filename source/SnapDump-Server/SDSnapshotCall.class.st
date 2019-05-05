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
		beInteger;
		required: true;
		description: 'Snapshot with unique id'

]

{ #category : #accessing }
SDSnapshotCall class >> path [
	^ '/snaps/{snapshotId}'
]

{ #category : #public }
SDSnapshotCall >> get [
	| fuelFile |
	fuelFile := self store snapshotWithId: request uri pathSegments second.
	response := ZnResponse ok: ((ZnStreamingEntity 
		type: ZnMimeType applicationOctetStream length: fuelFile size)
			stream: fuelFile readStream binary). 
]

{ #category : #accessing }
SDSnapshotCall >> head [
	response := (self store hasSnapshotNamed: request uri pathSegments second)
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
