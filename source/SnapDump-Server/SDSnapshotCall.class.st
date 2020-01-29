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
			(header = SDStore mimeTypeFuel)
				ifTrue: [ ^ self respondFuel: snapshot].
			 (header = SDStore mimeTypeStack)
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
	| file |
	"["
	"try to read header in ordert to find bogus data"
	(SDSnapshotFileReader on: request contents readStream) 
		initializeFromMeta"]
		on: ZnCharacterEncodingError  
		do: [:err | 
			^ response := ZnResponse 
				badRequest: request 
				entity: (ZnStringEntity text: err description) ]".
			
	file := self store 
		snapshotPathForProject: projectName
		version: versionString 
		exception: exceptionId 
		snapshot: snapshotId.
	
	"just write request entity to file as it might be big"
	(SDSnapshotFileWriter file: file) 
		writeRaw: request contents. 
	response := ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #public }
SDSnapshotCall >> respondFuel: aFileSnapshot [
	
	response := ZnResponse
		ok: aFileSnapshot newReader fuelDumpEntity 
]

{ #category : #public }
SDSnapshotCall >> respondStack: aFileSnapshot [

	response := ZnResponse
		ok: aFileSnapshot newReader stackTraceEntity
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
