Extension { #name : #SDProject }

{ #category : #'*SnapDump-UI' }
SDProject >> gtInspectorVersionsIn: composite [
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
		send: [ :list | list anyOne ]
]
