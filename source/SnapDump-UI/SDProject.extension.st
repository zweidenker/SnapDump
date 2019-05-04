Extension { #name : #SDProject }

{ #category : #'*SnapDump-UI' }
SDProject >> gtInspectorSubscriptionsIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite table
		title: [ 'Version' ];
		display: [ self versions ];
		beMultiple;
		column: 'Version' evaluated: [ :each | each string asString ];
		addAction: (GLMGenericAction new
				action: [ :table | self remove. table update ]; 
				iconName: #glamorousCancel;
				title: 'Remove Project' translated;
				shouldShowTitle: true);
		selectionAct: [ :table | 
				table selection do: [ :eachSelection | 
					self subscriptions remove: eachSelection ].
				table update ] 
			iconName: #glamorousCancel
			entitled: 'Reset subscription(s)' translated
]
