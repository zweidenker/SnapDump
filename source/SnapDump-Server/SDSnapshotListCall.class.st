Class {
	#name : #SDSnapshotListCall,
	#superclass : #SDOpenAPICall,
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotListCall class >> path [
	^ '/snapshots'
]

{ #category : #accessing }
SDSnapshotListCall >> get [
	self jsonResponse: self store snapshots. 
	
]
