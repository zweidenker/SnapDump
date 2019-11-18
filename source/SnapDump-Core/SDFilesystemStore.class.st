Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path',
		'snapshotOccurrencesLimit',
		'projects',
		'versions'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFilesystemStore class >> storeName [
	^ #file
]

{ #category : #services }
SDFilesystemStore >> buildExceptionFrom: aFileReference [
	.
	^ SDException new
			id: aFileReference basename;
			version: (self buildVersionFrom: aFileReference parent);
			yourself
]

{ #category : #services }
SDFilesystemStore >> buildProjectFrom: aFileReference [ 
	.
	^ SDProject new
			name: aFileReference basename;
			store: self;
			yourself
]

{ #category : #services }
SDFilesystemStore >> buildSnapshot: snapshotId exception: exceptionId project: projectName version: versionName [
	.
	^ (self buildSnapshot: snapshotId project: projectName version: versionName) exceptionId: exceptionId; yourself
]

{ #category : #services }
SDFilesystemStore >> buildSnapshot: snapshotId project: projectName version: versionName [
	.
	^ SDFileSnapshot new
		snapshotId: snapshotId;
		projectName: projectName;
		versionString: versionName;
		yourself
]

{ #category : #services }
SDFilesystemStore >> buildVersionFrom: aFileReference [ 
	.
	^ SDVersion new
			string: aFileReference basename;
			project: (self buildProjectFrom: aFileReference parent);
			yourself
]

{ #category : #'services - removing' }
SDFilesystemStore >> cleanSnapshotRemoval: file [
	
	| versionDirectory projectDirectory exceptionDirectory |
	exceptionDirectory := file parent.
	versionDirectory := exceptionDirectory parent.
	projectDirectory := versionDirectory parent.
	exceptionDirectory hasChildren ifFalse: [ exceptionDirectory delete ].
	versionDirectory hasChildren ifFalse: [ versionDirectory delete ].
	projectDirectory hasChildren ifFalse: [ projectDirectory delete  ].
	
]

{ #category : #accessing }
SDFilesystemStore >> exceptionAt: anExceptionId project: aProjectName version: aVersionName [
	| file |
	file := self
		snapshotPathForProject: aProjectName
		version: aVersionName
		exception: anExceptionId.
	file exists
		ifFalse: [ ^ nil ].
	self buildExceptionFrom: file
]

{ #category : #accessing }
SDFilesystemStore >> freeSlotsForException: anException [

	| snapshotSize |
	snapshotSize := anException snapshots size.
	 self snapshotOccurrencesLimit >= snapshotSize ifTrue: [^ 0].
	^ self snapshotOccurrencesLimit - snapshotSize
]

{ #category : #accessing }
SDFilesystemStore >> freeSlotsForExceptionId: anExceptionId project: projectName version: versionString [
	| directory numberOfFiles |
	directory := self
		snapshotPathForProject: projectName
		version: versionString
		exception: anExceptionId.
	directory exists
		ifFalse: [ ^ self snapshotOccurrencesLimit ].
	numberOfFiles := directory children size.
	numberOfFiles >= self snapshotOccurrencesLimit
		ifTrue: [ ^ 0 ].
	^ self snapshotOccurrencesLimit - numberOfFiles
]

{ #category : #accessing }
SDFilesystemStore >> freeSlotsForSnapshot: aSnapshot [

	^ self freeSlotsForExceptionId: aSnapshot exceptionId project: aSnapshot projectName version: aSnapshot versionString
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshot: aSnapshot [


	^ self hasSnapshot: aSnapshot snapshotId project: aSnapshot projectName version: aSnapshot versionString

]

{ #category : #testing }
SDFilesystemStore >> hasSnapshot: snapshotId project: aProjectName version: aVersionName [
	^ (self snapshotFilesForProject: aProjectName version: aVersionName)
		anySatisfy:
			[ :eachFile | eachFile basename = self snapshotFileNameFor: snapshotId ]
]

{ #category : #testing }
SDFilesystemStore >> isSetUp [
	^ path notNil
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory.
]

{ #category : #accessing }
SDFilesystemStore >> projectNamed: aString [ 

	| file project |
	file := self snapshotPathForProject: aString.
	file exists ifFalse: [NotFound signal].
	project := (SDProject name: aString) store: self.
	^ project
]

{ #category : #accessing }
SDFilesystemStore >> projectNamed: aString ifAbsent: aBlock [
	^ [self projectNamed: aString] on: NotFound do: [ :ex | aBlock value ]
]

{ #category : #accessing }
SDFilesystemStore >> projects [
	^ path children collect: [ :directory |
		 (SDProject name: directory basename) store: self.
		 ]
]

{ #category : #'services - removing' }
SDFilesystemStore >> removeProject: aProject [ 
	"projects are derived from snapshots. Nothing to do"
	^ aProject 
]

{ #category : #'services - removing' }
SDFilesystemStore >> removeSnapshot: snapshot [
	
	| file |
	file := (self snapshotPathFor: snapshot ).
	file delete.
	self cleanSnapshotRemoval: file.
	
]

{ #category : #'services - removing' }
SDFilesystemStore >> removeVersion: aVersion [ 
	"version are created from snapshots. So nothing to do"
]

{ #category : #testing }
SDFilesystemStore >> shouldReportSnapshot: snapshot [
	^ (self
		hasSnapshot: snapshot) not
		and: [ (self freeSlotsForSnapshot: snapshot) > 0]
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotFileNameFor: snapshotId [

	^ snapshotId , '.snap'
]

{ #category : #accessing }
SDFilesystemStore >> snapshotFiles [
	^ path allChildrenMatching: '*.snap'
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotFilesForProject: aProjectName version: aVersionName [

	| directory |
	directory := self snapshotPathForProject: aProjectName version: aVersionName.
	directory exists ifFalse: [ ^ #() ].
	^ directory allFiles
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotFilesForProject: aProjectName version: aVersionName exception: exceptionId [
	| directory |
	directory := self
		snapshotPathForProject: aProjectName
		version: aVersionName
		exception: exceptionId.
	directory exists
		ifFalse: [ ^ #() ].
	^ directory allFiles
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotIdFrom: aFileBasename [

	^ aFileBasename asFileReference basenameWithoutExtension
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

{ #category : #'services - files' }
SDFilesystemStore >> snapshotPathFor: aSnaphot [
	^ self
		snapshotPathForProject: aSnaphot projectName
		version: aSnaphot versionString
		exception: aSnaphot exceptionId
		snapshot: aSnaphot snapshotId
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotPathForProject: projectName [ 
	^ path / projectName 
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotPathForProject: projectName version: versionName [
	^ (self snapshotPathForProject: projectName) / versionName 
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotPathForProject: projectName version: versionName exception: exceptionId [
	^ (self snapshotPathForProject: projectName version: versionName)/ exceptionId
]

{ #category : #'services - files' }
SDFilesystemStore >> snapshotPathForProject: aProjectName version: aVersionName exception: exceptionId snapshot: snapshotId [
	^ (self
		snapshotPathForProject: aProjectName
		version: aVersionName
		exception: exceptionId) / (self snapshotFileNameFor: snapshotId)
]

{ #category : #services }
SDFilesystemStore >> snapshotWithId: anIdString project: aProjectName version: aVersionString [
	| file |
	file := (self
		snapshotFilesForProject: aProjectName
		version: aVersionString)
		detect:
			[ :eachFile | eachFile basename = (self snapshotFileNameFor: anIdString) ]
		ifNone: [ NotFound signal ].
	^ (self
		buildSnapshot: anIdString
		exception: file parent basename
		project: aProjectName
		version: aVersionString)
		file: file;
		yourself
]

{ #category : #services }
SDFilesystemStore >> snapshotsWithException: anException [

	^ (self
		snapshotFilesForProject: anException projectName
		version: anException versionString
		exception: anException id)
		collect: [ :eachFile | 
			(SDFileSnapshot fromFile: eachFile)  ]
]

{ #category : #services }
SDFilesystemStore >> snapshotsWithVersion: aVersion [

	^ (self
		snapshotFilesForProject: aVersion project name
		version: aVersion string)
		collect: [ :eachFile | 
			(SDFileSnapshot fromFile: eachFile)  ]
]

{ #category : #'services - adding' }
SDFilesystemStore >> storeRaw: snapshot contents: aByteArray [

	| file |
	file := (self snapshotPathFor: snapshot).
	file parent  ensureCreateDirectory. 
	snapshot file: file.
	snapshot storeRaw: aByteArray.

]

{ #category : #accessing }
SDFilesystemStore >> versionsOfProject: aProject [ 
	| file |
	file := (self snapshotPathForProject:  aProject name). 
	file exists ifFalse: [ ^ #() ].
	^ file children collect: [ :eachDirectory |
		(SDVersion string: eachDirectory basename) project: aProject
		 ].
]

{ #category : #'services - adding' }
SDFilesystemStore >> writeSnapshot: snapshot [
	| stream file |
	file := self snapshotPathFor: snapshot.
	file parent ensureCreateDirectory.
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ snapshot writeTo: stream ]
		ensure: [ stream close ]
]
