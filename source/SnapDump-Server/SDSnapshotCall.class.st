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
		in: #query;
		beString;
		required: false;
		description: 'Identify a given exception within the context of this server. Several snapshots can be reported for a same exceptionId'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #query;
		beString;
		required: false;
		allowEmptyValue: true;
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
		description: 'Identify a given snapshot within the context of this server'

]

{ #category : #accessing }
SDSnapshotCall class >> parameterVersionName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionName';
		in: #query;
		beString;
		allowEmptyValue: true;
		required: false;
		description: 'Version of the project to which a snapshot belongs to'

]

{ #category : #accessing }
SDSnapshotCall class >> path [
	^ '/snapshots/{snapshotId}'
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

	response := (self store hasSnapshotId: snapshotId exceptionId: exceptionId )
		ifTrue: [ ZnResponse ok: (ZnStringEntity text: 'OK') ]
		ifFalse: [ ZnResponse notFound: request uri ]
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot |

	[snapshot := self store buildSnapshotFrom: request contents readStream project: projectName version: versionName.
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
	^ self snapshotWithId: snapshotId
]
