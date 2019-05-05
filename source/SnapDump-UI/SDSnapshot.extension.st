Extension { #name : #SDSnapshot }

{ #category : #'*SnapDump-UI' }
SDSnapshot >> gtInspectorSnapshotIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite table
		title: [ 'Fields' ];
		display: [ self class instVarNames  ];
		column: 'Field' evaluated: [:s | s capitalized ];
		column: 'Value' evaluated: [:s | self perform: s ];
		addAction: (GLMGenericAction new
			action: [ :table | self openDebugger. table update ]; 
			iconName: #smallOpenIcon;
			title: 'Open Snapshot' translated;
			shouldShowTitle: true);
		addAction: (GLMGenericAction new
			action: [ :table | self remove. table update ]; 
			iconName: #glamorousCancel;
			title: 'Remove Snapshot' translated;
			shouldShowTitle: true)

]
