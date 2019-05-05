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

{ #category : #'as yet unclassified' }
SDFilesystemStore >> fuelFiles [
	^ path childrenMatching: '*.fuel'
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotNamed: snapshot [
	^ ( path / (self filenameFor: snapshot) ) exists
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectNamed: aString [ 
	^ self projects detect: [ :each | each name = aString ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projects [
	^ ((self fuelFiles collect: [ :each | SDFileSnapshot fuel: each ]) 
		collect: #project as: Set)
		collect: [ :each | 
			SDProject new 
				store: self;
				name: each ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> signaturesOfVersion: aVersion [ 
	^ (self fuelFiles collect: [ :each | SDFileSnapshot fuel: each ]) 
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
	"((path / snapshot id), #json) writeStream in: [ :s |
		snapshot writeMetaOn: s. 
		s close ]"
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> versionsOfProject: aProject [ 
	^ (((self fuelFiles collect: [ :each | SDFileSnapshot fuel: each ]) 
		select: [ :each | each project = aProject name ])
		collect: #version as: Set)
		collect: [ :each | 
			SDVersion new
				project: aProject;
				string: each ]
]
