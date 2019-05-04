Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path'
	],
	#category : #'SnapDump-Server-Store'
}

{ #category : #accessing }
SDFilesystemStore class >> storeName [
	^ #file
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> filenameFor: snapshot [
	^ snapshot id , '.fuel'
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotNamed: snapshot [
	^ ( path / (self filenameFor: snapshot) ) exists
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> hasSnapshotWithId: aString [ 
	| filePath |
	filePath := (path / aString), #json.
	^ filePath exists
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> jsonFiles [
	^ path childrenMatching: '*.json'
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> project: project version: version signature: signature [ 
	| file |
	^ ((path / signature) , '.json') asFileReference exists 
		ifTrue: [ 
			SDSnapshot fromDescription: (path / signature) , '.json' ]
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectNamed: aString [ 
	(path / aString) exists ifTrue: [ 
		^ SDProject new 
			name: aString ].
	NotFound signal: 'project not found'
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectWithName: aString [ 
	^ self projects detect: [ :each | each name = aString ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projects [
	^ ((self jsonFiles collect: [ :each | (NeoJSONReader on: each readStream) next ]) 
		collect: [ :each | each at: 'project' ] as: Set)
		collect: [ :each | 
			SDProject new 
				store: self;
				name: each ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> signaturesOfVersion: aVersion [ 
	^ (self jsonFiles collect: [ :each | SDFileSnapshot file: each withoutExtension ]) 
		select: [ :each | (each project = aVersion project name) and: [ each version = aVersion string ] ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotDumpWithId: aString [ 
	| filePath |
	filePath := (path / aString) asFileReference.
	^ SDFileSnapshot file: filePath 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotWithId: aString [ 
	| filePath |
	filePath := (path / aString), #json.
	^ filePath exists 
		ifTrue: [ SDFileSnapshot readFrom: filePath asFileReference readStream ] 
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> store: snapshot [
	| stream file |
	file := (path / snapshot id) , #fuel.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ].
	((path / snapshot id), #json) writeStream in: [ :s |
		snapshot writeMetaOn: s. 
		s close ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> storeDebugContext: aContext description: dict [
	| stream |
	stream := (path / (self filenameFor: dict) ) binaryWriteStream.
	[ self 
		serializeContext: aContext 
		on: stream ]
		ensure: [ stream close ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> versionsOfProject: aProject [ 
	^ (((self jsonFiles collect: [ :each | (NeoJSONReader on: each readStream) next ]) 
		select: [ :each | (each at: 'project') = aProject name ])
		collect: [ :each | each at: 'version' ] as: Set)
		collect: [ :each | 
			SDVersion new
				project: aProject;
				string: each ]
]
