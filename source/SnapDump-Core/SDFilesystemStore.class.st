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
SDFilesystemStore >> buildSnapshotFrom: stream project: projectName version: versionName [
	| project version snapshot dict |
	
	dict := SDFileSnapshot readMetaFrom: stream.
	snapshot := SDFileSnapshot new initializeMeta: dict.
	project := self projects 
		at: projectName
		ifAbsentPut: [ (SDProject name: projectName) store: self ].
	version := (SDVersion string: versionName) project: project.
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
	snapshots := self snapshotFiles collect: [ :file |
		(self buildSnapshotFrom: file binaryReadStream)
			file: file;
			yourself ] 
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshot: snapshot [
	^ ( self snapshotPathFor: snapshot ) exists
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshot: snapshotId project: projectName version: versionName exception: exceptionId [
	^ (self
		snapshotPathForId: snapshotId
		project: projectName
		version: versionName
		exceptionId: exceptionId) exists
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
SDFilesystemStore >> removeSnapshotWithId: aSnapshotId project: projectName version: versionName exception: exceptionId [ 
	
	(self snapshotPathForId: aSnapshotId project: projectName version: versionName exceptionId: exceptionId) delete.
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
SDFilesystemStore >> snapshotFiles [
	^ path allChildrenMatching: '*.snap'
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotPathFor: aSnaphot [
	^ self
		snapshotPathForId: aSnaphot snapshotId
		project: aSnaphot projectName
		version: aSnaphot versionString
		exceptionId: aSnaphot exceptionId
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotPathForId: snapshotId project: aProjectName version: aVersionName exceptionId: exceptionId [
	^ (((path / aProjectName)
		ensureCreateDirectory;
		/ aVersionName)
		ensureCreateDirectory;
		/ exceptionId) ensureCreateDirectory / snapshotId , #snap
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> snapshotWithId: aString project: aProjectName version: aVersionName exceptionId: anExceptionId [
	^ self snapshots
		detect: [ :each | 
			((each snapshotId = aString and: [ each projectName = aProjectName ])
				and: [ each versionString = aVersionName ])
				and: [ each exceptionId = anExceptionId ] ]
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
	snapshot file: (self snapshotPathFor: snapshot).
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
	file := self snapshotPathFor: snapshot.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ]
]
