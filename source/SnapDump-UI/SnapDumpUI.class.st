Class {
	#name : #SnapDumpUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'projectList',
		'versionList',
		'snapshotList',
		'snapshot',
		'snapDump',
		'client',
		'exceptionList'
	],
	#category : #'SnapDump-UI'
}

{ #category : #specs }
SnapDumpUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newRow: [ :row |
			row 
				newColumn: [ :c | c add: #projectList ] left: 0 right: 0.9;
				newColumn: [ :c | c add: #versionList ] left: 0.1 right: 0.825;
				newColumn: [ :c | c add: #exceptionList ] left: 0.175 right: 0.50;
				newColumn: [ :c | c add: #snapshotList ] left: 0.58 right: 0.30;
				newColumn: [ :c | c add: #snapshot ] left: 0.6 right: 0 ];
		yourself
]

{ #category : #example }
SnapDumpUI class >> example [ 

	|port server|
	port := 9993.
	server := (Smalltalk at: #SDServer) port: port path: './sd-ui-example' asFileReference.
	"server start."
	
	"configure the SnapDump client to access the docker container"
	SnapDump uri: 'http://localhost:', port asString,'/api'.
	"Uploaded a few snapshots to see something in the client"
	SDHandler fillExamples.
	"open the ui"
	SnapDump ui
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> client [
	^ client ifNil: [
		client := SnapDump client ]
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> exceptionList [
	^ exceptionList
]

{ #category : #api }
SnapDumpUI >> extent [ 
	^ 1000@400
]

{ #category : #initialization }
SnapDumpUI >> initializeExceptionList [
	exceptionList := self newMultiColumnList
		displayBlock: [ :anException | 
			{anException signalerSignature.
			anException exceptionClassName} ];
		sortingBlock: [ :a :b | a snapshots last timestamp < b snapshots last timestamp ];
		whenSelectedItemChanged: [ :anException | 
			self resetSnapshotsWith:  (anException ifNil: [ #() ] ifNotNil: [ anException snapshots ]).
			]
]

{ #category : #initialization }
SnapDumpUI >> initializeProjectList [
	projectList := self newList.
	projectList
		allowToSelect: false;
		items: self client projects;
		displayBlock: [ :m | m name ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectedItemChanged: [ :selection | 
			self resetVersionsWith: (selection ifNil: [ #() ] ifNotNil: [ :aProject | aProject versions ]).
			 ];
		allowToSelect: true
]

{ #category : #initialization }
SnapDumpUI >> initializeSnapshotList [
	snapshotList := self newMultiColumnList
		displayBlock: [ :s | {s dateAndTimeString} ];
		sortingBlock: [ :a :b | a timestamp < b timestamp ];
		whenSelectedItemChanged: [ :s | snapshot item: s ]
]

{ #category : #initialization }
SnapDumpUI >> initializeVersionList [
	versionList := self newList
		displayBlock: [ :m | m string ];
		sortingBlock: [ :a :b | a < b ];
		whenSelectedItemChanged: [ :version | 
			self resetExceptionsWith: 
					(version
						ifNil: [ #() ]
						ifNotNil: [ (version exceptions)]).
			]
]

{ #category : #initialization }
SnapDumpUI >> initializeWidgets [
	snapshot := SDSnapshotPresenter new.
	self initializeSnapshotList.
	self initializeExceptionList.
	self initializeVersionList.
	self initializeProjectList.
	snapshot whenChangedDo: [ :s | self updateLists ].
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> projectList [
	^ projectList
]

{ #category : #initialization }
SnapDumpUI >> resetExceptionsWith: aCollectionOfExceptions [

	exceptionList items: aCollectionOfExceptions.
	exceptionList resetSelection.
	snapshotList items: #()
]

{ #category : #initialization }
SnapDumpUI >> resetProjectsWith: aCollectionOfProjects [
	projectList items: aCollectionOfProjects.
	versionList resetSelection.
	versionList items: #().
	exceptionList items: #().
	snapshotList items: #()
]

{ #category : #initialization }
SnapDumpUI >> resetSnapshotsWith: aCollectionOfSnapshots [

	snapshotList items: aCollectionOfSnapshots.
	snapshotList resetSelection
]

{ #category : #initialization }
SnapDumpUI >> resetVersionsWith: aCollectionOfVersions [
	versionList items: aCollectionOfVersions.
	versionList resetSelection.
	exceptionList items: #().
	snapshotList items: #()
]

{ #category : #accessing }
SnapDumpUI >> snapDump: aSnapDump [ 
	snapDump := aSnapDump 
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> snapshot [
	^ snapshot
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> snapshotList [
	^ snapshotList
]

{ #category : #initialization }
SnapDumpUI >> subMenu [ 

	^ MenuPresenter new
		addGroup: [ :group |
			SnapDump current projects do: [ :project | 
				group addItem: [ :item |
					item
						name: project name;
						icon: (self iconNamed: #openIcon);
						action: [ self inform: project name ] ] ] ]
]

{ #category : #api }
SnapDumpUI >> title [
	^ 'SnapDump on ', snapDump store printString 
]

{ #category : #initialization }
SnapDumpUI >> updateLists [
	| project version projects exception |
	projects := self client projects.
	project := projects
		detect: [ :eachProject | 
			eachProject name
				= (projectList selectedItem ifNotNil: [ :selection | selection name ]) ]
		ifNone: [ ^ self resetProjectsWith: projects ].
	version := project versions
		detect: [ :eachVersion | 
			eachVersion string
				= (versionList selectedItem ifNotNil: [ :selection | selection string ]) ]
		ifNone: [ ^ self resetVersionsWith: project versions ].
	exception := (version exceptions) 
		detect: [ :eachException | 
			eachException id
				= (exceptionList selectedItem ifNotNil: [ :selection | selection id ]) ]
		ifNone: [ ^ self
				resetExceptionsWith: (version exceptions) ].

	exception snapshots
		detect: [ :eachSnap | 
			eachSnap snapshotId
				=
					(snapshotList selectedItem
						ifNotNil: [ :selection | selection snapshotId ]) ]
		ifNone: [ self resetSnapshotsWith: exception snapshots ]
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> versionList [
	^ versionList
]
