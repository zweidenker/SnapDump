Class {
	#name : #SDSnapshotCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'snapshotId',
		'projectName',
		'versionName',
		'exceptionId'
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
		description: 'An exception unique id within the outter project-version context. Several snapshots can be reported for a single exceptionId'

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
		description: 'Snapshot with unique id within the outter project-version-exception context'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterVersionName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionName';
		in: #path;
		beString;
		required: true;
		description: 'Version of the project to which a snapshot belongs to'

]

{ #category : #accessing }
SDSnapshotCall class >> path [
	^ 'projects/{projectName}/versions/{versionName}/exceptions/{exceptionId}/snapshots/{snapshotId}'
]

{ #category : #'submorphs-add/remove' }
SDSnapshotCall >> delete [
	[self store removeSnapshotWithId: snapshotId project: projectName version: versionName exception: exceptionId]
		on: FileDoesNotExistException 
		do: [ :err | ^ response := ZnResponse notFound: request uri ] .
	response := ZnResponse ok: (ZnStringEntity text: 'OK') 
]

{ #category : #public }
SDSnapshotCall >> get [
	| fuelFile json |
	json := true.
	fuelFile := self snapshot.
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
	response := (self store hasSnapshot: snapshotId project: projectName version: versionName exception: exceptionId)
		ifTrue: [ ZnResponse ok: (ZnStringEntity text: 'OK') ]
		ifFalse: [ ZnResponse notFound: request uri ]
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot |
	[snapshot := self store buildSnapshotFrom: request contents readStream project: projectName version: versionName.
	snapshot sanitize.
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
SDSnapshotCall >> snapshot [
	^ self snapshotWithId: snapshotId  project: projectName version: versionName exceptionId: exceptionId
]
