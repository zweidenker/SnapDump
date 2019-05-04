Extension { #name : #SDVersion }

{ #category : #'*SnapDump-UI' }
SDVersion >> gtInspectorSubscriptionsIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite table
		title: [ 'Version' ];
		display: [ self signatures ];
		beMultiple;
		column: 'DateAndTime' evaluated: [ :each | each dateAndTime rounded asString ];
		column: 'Selector' evaluated: [ :each | each classSelector asString ];
		column: 'Exception' evaluated: [ :each | each exceptionClass asString ];
		addAction: (GLMGenericAction new
				action: [ :table | self remove. table update ]; 
				iconName: #glamorousCancel;
				title: 'Remove Version' translated;
				shouldShowTitle: true);
		selectionAct: [ :table | 
				table selection do: [ :eachSelection | 
					eachSelection remove ].
				table update ] 
			entitled: 'Delete' translated;
		send: [ :s | s anyOne ]
]
