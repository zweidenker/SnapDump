Extension { #name : #SDSnapshot }

{ #category : #'*SnapDump-UI' }
SDSnapshot >> gtInspectorSubscriptionsIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite fastList
		title: [ 'Fields' ];
		display: [ self class instVarNames collect: [ :each | self perform: each ] ];
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
