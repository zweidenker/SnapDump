Class {
	#name : #SDSnapshotListCall,
	#superclass : #SDOpenAPICall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotListCall class >> path [
	^ #( '/snapshots' )
]

{ #category : #accessing }
SDSnapshotListCall >> get [
	self halt.
	self jsonResponse: (self configurations collect: #project) asSet. 
	
]
