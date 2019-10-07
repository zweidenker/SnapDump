Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path',
		'snapshots',
		'projects',
		'versions',
		'snapshotOccurrencesLimit'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFilesystemStore class >> storeName [
	^ #file
]

{ #category : #private }
SDFilesystemStore >> buildSnapshotFrom: stream [
	
		^ self buildSnapshotFrom: stream project: nil version: nil
]

{ #category : #services }
SDFilesystemStore >> buildSnapshotFrom: stream project: projectName version: versionName [
	| project version snapshot dict |
	
	dict := SDFileSnapshot readMetaFrom: stream.
	snapshot := SDFileSnapshot new initializeMeta: dict.
	self ensureProjectTo: snapshot with: projectName.
	self ensureVersionTo: snapshot with: versionName.
	project := self projects 
		at: snapshot projectName
		ifAbsentPut: [ (SDProject name: snapshot projectName) store: self ].
	version := (SDVersion string: snapshot versionString) project: project; yourself.
	(versions
		at: project
		ifAbsentPut: [ Set new ]) add: version.
		
	^ snapshot
		project: project;
		version: version;
		yourself
]

{ #category : #private }
SDFilesystemStore >> buildSnapshots [
	projects := Dictionary new.
	versions := Dictionary new.
	snapshots := self snapshotFiles collect: [ :file |
		(self buildSnapshotFrom: file binaryReadStream)
			file: file;
			yourself ] 
]

{ #category : #accessing }
SDFilesystemStore >> defaultSnapshotOccurrencesLimit [

	^ 10
	
	
]

{ #category : #private }
SDFilesystemStore >> ensureProjectTo: snapshot with: projectName [
	snapshot projectName isEmptyOrNil
		ifTrue: [ projectName isEmptyOrNil
				ifTrue: [ snapshot projectName: SDProject defaultProjectName]
				ifFalse: [ snapshot projectName: projectName ] ].
	^ snapshot projectName
]

{ #category : #private }
SDFilesystemStore >> ensureVersionTo: snapshot with: versionName [
	snapshot versionString isEmptyOrNil
		ifTrue: [ versionName isEmptyOrNil
				ifTrue: [ snapshot versionString: SDVersion defaultVersionString ]
				ifFalse: [ snapshot versionString: versionName ] ].
	^ snapshot versionString
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshot: snapshot [
	^ self hasSnapshotId: snapshot snapshotId exceptionId:  snapshot exceptionId
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotId: snapshotId exceptionId: exceptionId [
	^ (self snapshots anySatisfy: [:eachSnapshot | eachSnapshot snapshotId = snapshotId])
	 or: [ 
				(self numberOfSnapshotsForException: exceptionId) >= self snapshotOccurrencesLimit 
			 ]
]

{ #category : #testing }
SDFilesystemStore >> isSetUp [
	^ path notNil
]

{ #category : #accessing }
SDFilesystemStore >> numberOfSnapshotsForException: anExceptionId [

	^ (self snapshotsForException: anExceptionId) size
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory.
	self reset
]

{ #category : #accessing }
SDFilesystemStore >> projectNamed: aString [ 
	^ self projects at: aString 
]

{ #category : #accessing }
SDFilesystemStore >> projectNamed: aString ifAbsent: aBlock [
	^ self projects 
		at: aString
		ifAbsent: aBlock
]

{ #category : #accessing }
SDFilesystemStore >> projectNamed: aString ifAbsentPut: aBlock [
	^ self projects 
		at: aString 
		ifAbsentPut: aBlock
]

{ #category : #accessing }
SDFilesystemStore >> projects [
	^ projects 
]

{ #category : #services }
SDFilesystemStore >> removeProject: aProject [ 
	"projects are derived from snapshots. Nothing to do"
	^ aProject 
]

{ #category : #services }
SDFilesystemStore >> removeSnapshot: snapshot [
	
	(self snapshotPathFor: snapshot ) delete.
	self reset
	
]

{ #category : #services }
SDFilesystemStore >> removeVersion: aVersion [ 
	"version are created from snapshots. So nothing to do"
]

{ #category : #services }
SDFilesystemStore >> reset [
	super reset.
	snapshots := nil.
	projects := nil.
	versions := nil.
	self buildSnapshots 
]

{ #category : #accessing }
SDFilesystemStore >> snapshotFiles [
	^ path allChildrenMatching: '*.snap'
]

{ #category : #accessing }
SDFilesystemStore >> snapshotOccurrencesLimit [
	"answers the maximum number of snapshots that should be stored for a same exception id"
	
		^ snapshotOccurrencesLimit ifNil: [ snapshotOccurrencesLimit := self defaultSnapshotOccurrencesLimit  ]
	
	
]

{ #category : #accessing }
SDFilesystemStore >> snapshotOccurrencesLimit: aNumber [
	
		snapshotOccurrencesLimit := aNumber
	
	
]

{ #category : #services }
SDFilesystemStore >> snapshotPathFor: aSnaphot [
	^ self
		snapshotPathForId: aSnaphot snapshotId
		project: aSnaphot projectName
		version: aSnaphot versionString
]

{ #category : #services }
SDFilesystemStore >> snapshotPathForId: snapshotId project: aProjectName version: aVersionName [
	^ (((path / aProjectName)
		ensureCreateDirectory;
		/ aVersionName)
		ensureCreateDirectory)/ snapshotId , #snap
]

{ #category : #services }
SDFilesystemStore >> snapshotWithId: aString [ 
	^ self snapshots
		detect: [ :each | 
			each snapshotId = aString ]
		ifNone: [ NotFound signal ]
]

{ #category : #accessing }
SDFilesystemStore >> snapshots [
	^ snapshots 
		
]

{ #category : #accessing }
SDFilesystemStore >> snapshotsForException: anExceptionId [

	^ self snapshots select: [ :eachSnapshot |
			eachSnapshot exceptionId = anExceptionId
		 ]
]

{ #category : #services }
SDFilesystemStore >> snapshotsWithProject: projectName version: versionString [
	^ self snapshots
		select: [ :each | (each project name = projectName) and: [ each version string = versionString] ]
]

{ #category : #services }
SDFilesystemStore >> snapshotsWithVersion: aVersion [ 
	^ self snapshots
		select: [ :each | (each project name = aVersion project name) and: [ each version string = aVersion string ] ]
]

{ #category : #services }
SDFilesystemStore >> storeRaw: snapshot contents: aByteArray [
	snapshot file: (self snapshotPathFor: snapshot).
	snapshot storeRaw: aByteArray.
	self reset
]

{ #category : #accessing }
SDFilesystemStore >> versionsOfProject: aProject [ 
	^ versions at: aProject ifAbsent: [ #() ]
]

{ #category : #services }
SDFilesystemStore >> writeSnapshot: snapshot [
	| stream file |
	file := self snapshotPathFor: snapshot.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ]
]
