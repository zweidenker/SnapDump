Extension { #name : #SnapDump }

{ #category : #'*SnapDump-UI' }
SnapDump >> gtInspectorSubscriptionsIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite table
		title: [ 'Projects' ];
		display: [ self projects ];
		beMultiple;
		column: 'Project' evaluated: [ :each | each name asString ]
]
