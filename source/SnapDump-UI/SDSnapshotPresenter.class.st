Class {
	#name : #SDSnapshotPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'menu',
		'meta',
		'snapshot'
	],
	#category : #'SnapDump-UI'
}

{ #category : #specs }
SDSnapshotPresenter class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newRow: [ :c | c add: #menu ] origin: 0@0 corner: 1@0.05;
		newRow: [ :c | c add: #meta ] origin: 0@0.05 corner: 1@1 ;
		yourself
]

{ #category : #initialization }
SDSnapshotPresenter >> initializeWidgets [
	menu := MenuPresenter new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open Snapshot';
						description: 'Open Snapshot';
						icon: (self iconNamed: #openIcon);
						action: [ snapshot ifNotNil: [snapshot openDebugger] ] ].
			group
				addItem: [ :item | 
					item
						name: 'Remove Snapshot';
						description: 'Remove Snapshot';
						icon: (self iconNamed: #smallWarningIcon);
						action: [ self removeSnapshot
							  ] ]. 
					
			group
				addItem: [ :item | 
					item
						name: 'Stack trace';
						description: 'View stack trace';
						icon: (self iconNamed: #transcript);
						action: [ snapshot ifNotNil: [snapshot openStackTrace] ] ].		
					].
	menu applyTo: self.
	meta := self newMultiColumnList 
		displayBlock: [ :key | { key . (Text fromString: (snapshot perform: key) printString) }  ]
]

{ #category : #'as yet unclassified' }
SDSnapshotPresenter >> item [
	^ snapshot
]

{ #category : #'as yet unclassified' }
SDSnapshotPresenter >> item: aSnapshot [ 
	snapshot := aSnapshot.
	snapshot 
		ifNotNil: [
			meta items: snapshot metaFields.
			menu enable ]
		ifNil: [ 
			meta items: { }.
			menu disable ]
]

{ #category : #'as yet unclassified' }
SDSnapshotPresenter >> menu [
	^ menu
]

{ #category : #'as yet unclassified' }
SDSnapshotPresenter >> meta [
	^ meta
]

{ #category : #initialization }
SDSnapshotPresenter >> removeSnapshot [
	snapshot remove.
	snapshot := nil.
	self valueChanged
	
]

{ #category : #'as yet unclassified' }
SDSnapshotPresenter >> snapshot [
	^ snapshot
]
