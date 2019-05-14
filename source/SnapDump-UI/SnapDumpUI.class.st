Class {
	#name : #SnapDumpUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'projectList',
		'versionList',
		'snapshotList',
		'snapshot',
		'snapDump',
		'client'
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
				newColumn: [ :c | c add: #snapshotList ] left: 0.175 right: 0.40;
				newColumn: [ :c | c add: #snapshot ] left: 0.6 right: 0 ];
		yourself
]

{ #category : #'as yet unclassified' }
SnapDumpUI >> client [
	^ client ifNil: [
		client := SnapDump client ]
]

{ #category : #api }
SnapDumpUI >> extent [ 
	^ 1000@400
]

{ #category : #initialization }
SnapDumpUI >> initializeWidgets [
	snapshot := SDSnapshotPresenter new.
	snapshotList := self newMultiColumnList
		displayBlock: [ :m | { (m timestamp asDate printFormat: #(1 2 3 $. 1 1)), ' ', (m timestamp asTime print24 ). m methodSignature . m exceptionClass }  ];
		whenSelectedItemChanged: [ :s | 
			snapshot item: s ].
	versionList := self newList
		displayBlock: [ :m | m string ];
		whenSelectedItemChanged: [ :version | 
			self selectedVersion: version ].
	projectList := self newList .
	snapshot whenChangedDo: [:s | 
		[
		snapshotList resetSelection.
		snapshotList items: versionList selectedItem snapshots.
		]
			on: NotFound 
			do: [ :err | 
				snapshotList items: { }.
				versionList resetSelection ".versionList items: projectList selectedItem versions. " ]  ]. 
	projectList
		allowToSelect: false;
		items: self client projects;
		displayBlock: [ :m | m name ];
		whenSelectedItemChanged: [ :selection | 
			(selection isKindOf: SDProject) 
			ifTrue: [ 
				[versionList items: selection versions] 
					on: NotFound 
					do: [:err |.
						projectList items: snapDump projects ] ]
			ifFalse: [ projectList items: snapDump projects ] ];
		allowToSelect: true.

]

{ #category : #'as yet unclassified' }
SnapDumpUI >> projectList [
	^ projectList
]

{ #category : #initialization }
SnapDumpUI >> selectedVersion: version [
	version 
		ifNotNil: [ snapshotList items: version snapshots ]
		ifNil: [ 
			projectList selectedItem 
			ifNotNil: [  
				[ versionList items: projectList selectedItem versions ]
					on: NotFound 
					do: [ :err | 
						versionList items: {  }.
						projectList resetSelection ] ]
			ifNil: [ snapshotList items: {  } ] ]
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

{ #category : #'as yet unclassified' }
SnapDumpUI >> versionList [
	^ versionList
]
