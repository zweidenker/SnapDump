Extension { #name : #SDClient }

{ #category : #'*SnapDump-UI' }
SDClient >> gtInspectorSubscriptionsIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite table
		title: [ 'Projects' ];
		display: [ self projects ];
		beMultiple;
		column: 'Project' evaluated: [ :each | each name asString ];
		send: [ :s | s anyOne]
]
