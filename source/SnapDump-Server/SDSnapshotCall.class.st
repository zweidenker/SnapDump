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
		allowEmptyValue: false;
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
		allowEmptyValue: false;
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
		required: false;
		allowEmptyValue: false;
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

	self validateRequiredParameters: #(exceptionId projectName versionName).
	[ self snapshot ]
		on: NotFound
		do: [ :ex | 
			(self store
				shouldReportProject: projectName
				version: versionName
				exception: exceptionId)
				ifTrue: [ ^ ZnResponse notFound: request uri ] ].
	ZnResponse ok: (ZnStringEntity text: 'OK')
]

{ #category : #public }
SDSnapshotCall >> put [
| snapshot dict |

	self validateRequiredParameters: #(projectName versionName exceptionId).
	[
	snapshot := self store buildSnapshot: snapshotId exception: exceptionId project: projectName version: versionName.
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
SDSnapshotCall >> snapshot [
	[ (projectName isNil or: [ versionName isNil ])
		ifTrue: [ 
			"here we give the possibility to fetch a given snapshot from its snapshotId only.
			handy but slower than fetching with a known project and version "
			^ self store snapshotWithId: snapshotId ].
	^ self store
		snapshotWithId: snapshotId
		project: projectName
		version: versionName ]
		on: NotFound
		do: [ :err | ZnRespond signalWith: (ZnResponse notFound: request url) ]
]

{ #category : #public }
SDSnapshotCall >> validateRequiredParameters: aCollectionOfParameterNames [

 	aCollectionOfParameterNames do: [ :eachParameterName |
		(self instVarNamed: eachParameterName) isEmptyOrNil ifTrue: [ 
			OAMissingRequiredParameter signal: 'parameter ' , eachParameterName , ' is required but not present'
			 ]
		 ]
]
