Class {
	#name : #SnapDumpUI,
	#superclass : #SpPresenter,
	#instVars : [
		'projectList',
		'versionList',
		'snapshotList',
		'snapshot',
		'snapDump',
		'client',
		'exceptionList',
		'exceptionMenu',
		'menuBar',
		'selectedProject'
	],
	#category : #'SnapDump-UI'
}

{ #category : #layout }
SnapDumpUI class >> defaultLayout [
	<spec: #default>
	
	^ SpBoxLayout newTopToBottom
		add: #menuBar expand: false;
		add: (SpBoxLayout newLeftToRight 
			add: #versionList withConstraints: [ :constraints | constraints width: 150 ];
			add: #exceptionList;
			add: #snapshotList;
			add: #snapshot;
		yourself)
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

{ #category : #'as yet unclassified' }
SnapDumpUI >> exceptionMenu [
	^ exceptionMenu
]

{ #category : #api }
SnapDumpUI >> extent [ 
	^ 1000@400
]

{ #category : #initialization }
SnapDumpUI >> initializeExceptionButtons [
	exceptionMenu := SpMenuPresenter new
		autoRefresh: true;
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item 
						name: 'Remove Exception';
						description: 'Remove selecteed exception';
						"icon: (self iconNamed: #smallWarningIcon) ]"
						action: [ exceptionList selectedItem
									ifNotNil: [ :anException | 
										self removeException: anException.
										self refreshVersionList ] ] ];
				addItem: [ :item | 
					item 
						name: 'Remove All';
						description: 'Remove all Exceptions';
						"icon: (self iconNamed: #smallWarningIcon) ]"
						action: [ 
										self removeAllExceptions.
										self refreshVersionList ] ] ] 
]

{ #category : #initialization }
SnapDumpUI >> initializeExceptionList [
	
	exceptionList := self newList
		display: [ :anException | anException exceptionClassName, ' -> ', anException signalerSignature ];
		sortingBlock: [ :a :b | a snapshots last timestamp < b snapshots last timestamp ];
		whenSelectedDo: [ :anException | 
			self resetSnapshotsWith:  (anException ifNil: [ #() ] ifNotNil: [ anException snapshots ]).
			]
]

{ #category : #initialization }
SnapDumpUI >> initializeMenuBar [
	menuBar := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Project';
						subMenu: self subMenu ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Remove';
						action: [ self removeException: exceptionList selectedItem ] ];
				addItem: [ :item |
					item 
						name: 'Remove All';
						action: [ self removeAllExceptions ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open snapshot';
						action: [ snapshotList selectedItem openDebugger] ];
				addItem: [ :item |
					item 
						name: 'Stack trace';
						action: [ snapshotList selectedItem openStackTrace ] ];
				addItem: [ :item |
					item 
						name: 'Remove snapshot';
						action: [ self removeSnapshot  ] ]  ].
	menuBar addKeybindingsTo: self.
]

{ #category : #initialization }
SnapDumpUI >> initializeProjectList [
	projectList := self newList.
	projectList
		"allowToSelect: false;"
		items: self client projects;
		display: [ :m | m name ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectedDo:  [ :selection | 
			self resetVersionsWith: (selection ifNil: [ #() ] ifNotNil: [ :aProject | aProject versions ]).
			 ]";
		allowToSelect: true"
]

{ #category : #initialization }
SnapDumpUI >> initializeSnapshotList [
	snapshotList := self newList
		display: [ :s | s dateAndTimeString ];
		sortingBlock: [ :a :b | a timestamp < b timestamp ];
		whenSelectedDo: [ :s | snapshot items: s metaProperties associations ]
]

{ #category : #initialization }
SnapDumpUI >> initializeVersionList [
	versionList := self newList
		display: [ :m | m string ];
		sortingBlock: [ :a :b | a < b ];
		whenSelectedDo: [ :version | 
			self resetExceptionsWith: 
					(version
						ifNil: [ #() ]
						ifNotNil: [ (version exceptions)]).
			]
]

{ #category : #initialization }
SnapDumpUI >> initializeWidgets [
	snapshot := self newTable 
		beResizable;
		addColumn: (SpStringTableColumn title: 'Key' evaluated: #key);
		addColumn: (SpStringTableColumn title: 'Text' evaluated: #value).
	self initializeSnapshotList.
	self initializeExceptionButtons.
	self initializeExceptionList.
	self initializeVersionList.
	self initializeProjectList.
	self initializeMenuBar.
	snapshot whenChangedDo: [ :s | self updateLists ].
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> projectList [
	^ projectList
]

{ #category : #initialization }
SnapDumpUI >> refreshVersionList [
	self resetVersionsWith: selectedProject versions
]

{ #category : #initialization }
SnapDumpUI >> removeAllExceptions [
	exceptionList items do: [:exception | 
		exception snapshots do: #remove ].
	self refreshVersionList
]

{ #category : #initialization }
SnapDumpUI >> removeException: anException [ 
	
	anException snapshots do: [ :each | each remove ].
	exceptionList items: (exceptionList items copyWithout: anException)
]

{ #category : #initialization }
SnapDumpUI >> removeSnapshot [ 
	| item |
	item := snapshotList selectedItem.
	item remove.
	snapshotList items: (snapshotList items copyWithout: item) 
]

{ #category : #initialization }
SnapDumpUI >> resetExceptionsWith: aCollectionOfExceptions [

	exceptionList items: aCollectionOfExceptions.
	exceptionList resetListSelection.
	snapshotList items: #()
]

{ #category : #initialization }
SnapDumpUI >> resetProjectsWith: aCollectionOfProjects [
	projectList items: aCollectionOfProjects.
	versionList resetListSelection.
	versionList items: #().
	exceptionList items: #().
	snapshotList items: #()
]

{ #category : #initialization }
SnapDumpUI >> resetSnapshotsWith: aCollectionOfSnapshots [

	snapshotList items: aCollectionOfSnapshots.
	snapshotList resetListSelection
]

{ #category : #initialization }
SnapDumpUI >> resetVersionsWith: aCollectionOfVersions [
	versionList items: aCollectionOfVersions.
	versionList resetListSelection.
	exceptionList items: #().
	snapshotList items: #()
]

{ #category : #initialization }
SnapDumpUI >> restoreSelectedVersion [
"	| version project selectedProject |
	version := versionList selectedItem string.
	project := projectList selectedItem name.
	self resetProjectsWith: self client projects.
	selectedProject := projectList items
		detect: [ :each | each name = project ]
		ifNone: [ ^ self ].
	projectList selectItem: selectedProject.
	self resetVersionsWith: projectList selectedItem versions.
	versionList
		selectItem:
			(versionList items
				detect: [ :each | each string = version ]
				ifNone: [ versionList items first ])."
]

{ #category : #accessing }
SnapDumpUI >> selectedProject: aProject [
	selectedProject := aProject.
	self resetVersionsWith: selectedProject versions
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

	^ SpMenuPresenter new
		addGroup: [ :group |
			client projects do: [ :project | 
				group addItem: [ :item |
					item
						name: project name;
						action: [ 
							self selectedProject: project ] ] ] ]
			
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
