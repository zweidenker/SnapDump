Class {
	#name : #SDSnapshotCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'snapshotId',
		'projectName',
		'exceptionId',
		'versionString'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotCall class >> parameterExceptionId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'exceptionId';
		in: #path;
		beString;
		required: true;
		description: 'Identify a given exception within the context of this server. Several snapshots can be reported for a same exceptionId'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project to which a snapshot belongs to'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterSnapshotId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'snapshotId';
		in: #path;
		beString;
		required: true;
		description: 'Snapshot identifier'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version of the project to which a snapshot belongs to'

]

{ #category : #accessing }
SDSnapshotCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/exceptions/{exceptionId}/snapshots/{snapshotId}'
]

{ #category : #'submorphs-add/remove' }
SDSnapshotCall >> delete [
	[self store removeSnapshot: self snapshot]
		on: FileDoesNotExistException 
		do: [ :err | ^ response := ZnResponse notFound: request uri ] .
	response := ZnResponse ok: (ZnStringEntity text: 'OK') 
]

{ #category : #public }
SDSnapshotCall >> get [
	| snapshot json |
	json := true.
	snapshot := self snapshot.
	request headers 
		at: 'Accept'
		ifPresent: [ :header | 
			(header = 'application/X-SnapDump-Fuel')
				ifTrue: [ ^ self respondFuel: snapshot].
			 (header = 'application/X-SnapDump-Stack')
				ifTrue: [ ^ self respondStack: snapshot].].
	
	self jsonResponse: snapshot 
		
]

{ #category : #accessing }
SDSnapshotCall >> head [

	[ self snapshot ]
		on: NotFound
		do: [ :ex | 
		 ^ ZnResponse notFound: request uri ].
	ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot dict |

	[
	snapshot := self store buildSnapshot: snapshotId exception: exceptionId project: projectName version: versionString.
	"still need to read the meta data to get all variables initialized before being written on disk "
	dict := SDFileSnapshot readMetaFrom: request contents readStream.
	snapshot initializeMeta: dict.
	snapshot validate]
	on: ZnCharacterEncodingError  
	do: [:err | 
		^ response := ZnResponse 
			badRequest: request 
			entity: (ZnStringEntity text: err description) ].
	self store storeRaw: snapshot contents: request contents.
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #public }
SDSnapshotCall >> respondFuel: aFileSnapshot [
	response := ZnResponse
		ok:
			((ZnStreamingEntity
				type: ZnMimeType applicationOctetStream
				length: aFileSnapshot fileSize)
				stream: aFileSnapshot contentStream)
]

{ #category : #public }
SDSnapshotCall >> respondStack: aFileSnapshot [
	response := ZnResponse
		ok:
			((ZnStreamingEntity
				type: ZnMimeType applicationOctetStream
				length: aFileSnapshot fileSize)
				stream: aFileSnapshot stackTraceStream )
]

{ #category : #public }
SDSnapshotCall >> snapshot [
	[  
	^ self store
		snapshotWithId: snapshotId
		project: projectName
		version: versionString ]
		on: NotFound
		do: [ :err | ZnRespond signalWith: (ZnResponse notFound: request url) ]
]
