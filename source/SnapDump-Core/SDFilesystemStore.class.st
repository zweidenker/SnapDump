Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path',
		'projects',
		'versions'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFilesystemStore class >> storeName [
	^ #file
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> buildSnapshots [
	projects := Dictionary new.
	^ self fuelFiles collect: [ :file | | header projectName project versionString |
		header := FLMaterializer new materializeHeaderFrom: file binaryReadStream.
		projectName := header additionalObjectAt: #projectName.
		project := projects 
			at: projectName
			ifAbsentPut: [ (SDProject name: projectName) store: self ].
		versionString := header additionalObjectAt: #versionString.
		project 
			versionAt: versionString 
			ifAbsentPut: [ SDVersion string: versionString ].
		
		SDFileSnapshot new 
			file: file;
			setFuelHeader: header ] 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> fuelFiles [
	^ path childrenMatching: '*.fuel'
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotNamed: snapshotId [
	^ ( self snapshotPathFor: snapshotId ) exists
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectNamed: aString [ 
	^ self projects at: aString 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectNamed: aString ifAbsent: aBlock [
	^ self projects 
		at: aString
		ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projectNamed: aString ifAbsentPut: aBlock [
	^ self projects 
		at: aString 
		ifAbsentPut: aBlock
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> projects [
	^ projects ifNil: [ 
		self snapshots.
		projects  ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeSnapshot: aSnapshot [ 
	
	self removeSnapshotWithId: aSnapshot id
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeSnapshotWithId: aString [ 
	
	(self snapshotPathFor: aString) delete.
	
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotFromFile: aFileReference [
	^ SDFileSnapshot fromFile: aFileReference store: self 

]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotPathFor: aString [ 
	^ (path / aString) , #fuel
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotWithId: aString [ 
	| filePath |
	filePath := (path / aString), #fuel.
	^ filePath exists 
		ifTrue: [ self snapshotFromFile: filePath  ] 
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotsWithVersion: aVersion [ 
	^ self snapshots
		select: [ :each | (each project name = aVersion project name) and: [ each version string = aVersion string ] ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> store: snapshot [
	| stream file |
	file := (path / snapshot id) , #fuel.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> versionsOfProject: aProject [ 
	^ versions at: aProject 
]
