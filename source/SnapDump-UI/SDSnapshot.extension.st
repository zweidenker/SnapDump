Extension { #name : #SDSnapshot }

{ #category : #'*SnapDump-UI' }
SDSnapshot >> openStackTrace [
	UIManager default edit: (
		self store snapshotStackFor: self )
]
