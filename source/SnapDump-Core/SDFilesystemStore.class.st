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
SDFilesystemStore >> buildSnapshotFrom: stream [
	| header projectName project versionString version |
	
	header := FLMaterializer new materializeHeaderFrom: stream.
	projectName := header additionalObjectAt: #projectName.
	project := self projects 
		at: projectName
		ifAbsentPut: [ (SDProject name: projectName) store: self ].
	versionString := header additionalObjectAt: #versionString.
	version := (SDVersion string: versionString) project: project.
	(versions
		at: project
		ifAbsentPut: [ OrderedCollection new ]) add: version.
		
	^ SDFileSnapshot new 
		project: project;
		version: version;
		setFuelHeader: header;
		yourself
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> buildSnapshots [
	projects := Dictionary new.
	versions := Dictionary new.
	^ self fuelFiles collect: [ :file |
		(self buildSnapshotFrom: file binaryReadStream)
			file: file;
			yourself ] 
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
		projects ]
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeSnapshot: aSnapshot [ 
	
	self removeSnapshotWithId: aSnapshot id.

]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeSnapshotWithId: aString [ 
	
	(self snapshotPathFor: aString) delete.
	self reset
	
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> reset [
	super reset.
	projects := nil.
	versions := nil
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotPathFor: aString [ 
	^ (path / aString) , #fuel
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotWithId: aString [ 
	^ self snapshots 
		detect: [ :each | each id = aString ]
		ifNone: [ NotFound signal ]
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
SDFilesystemStore >> storeRaw: snapshot contents: aByteArray [
	snapshot file: (self snapshotPathFor: snapshot id).
	snapshot storeRaw: aByteArray.
	self reset
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> versionsOfProject: aProject [ 
	^ versions at: aProject ifAbsent: [ #() ]
]
