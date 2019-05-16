Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path',
		'snapshots',
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
	| projectName project versionString version snapshot dict |
	
	dict := SDFileSnapshot readMetaFrom: stream.
	snapshot := SDFileSnapshot new initializeMeta: dict.
	projectName := dict at: #projectName.
	project := self projects 
		at: projectName
		ifAbsentPut: [ (SDProject name: projectName) store: self ].
	versionString := dict at: #versionString.
	version := (SDVersion string: versionString) project: project.
	(versions
		at: project
		ifAbsentPut: [ Set new ]) add: version.
		
	^ snapshot
		project: project;
		version: version;
		yourself
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> buildSnapshots [
	projects := Dictionary new.
	versions := Dictionary new.
	snapshots := self fuelFiles collect: [ :file |
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

{ #category : #testing }
SDFilesystemStore >> isSetUp [
	^ path notNil
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory.
	self reset
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
	^ projects 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeProject: aProject [ 
	"projects are derived from snapshots. Nothing to do"
	^ aProject 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeSnapshotWithId: aString [ 
	
	(self snapshotPathFor: aString) delete.
	self reset
	
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> removeVersion: aVersion [ 
	"version are created from snapshots. So nothing to do"
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> reset [
	super reset.
	snapshots := nil.
	projects := nil.
	versions := nil.
	self buildSnapshots 
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

{ #category : #accessing }
SDFilesystemStore >> snapshots [
	^ snapshots 
		
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotsWithVersion: aVersion [ 
	^ self snapshots
		select: [ :each | (each project name = aVersion project name) and: [ each version string = aVersion string ] ]
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

{ #category : #'as yet unclassified' }
SDFilesystemStore >> writeSnapshot: snapshot [
	| stream file |
	file := (path / snapshot id) , #fuel.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ]
]
