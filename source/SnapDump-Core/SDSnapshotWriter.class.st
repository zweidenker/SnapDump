Class {
	#name : #SDSnapshotWriter,
	#superclass : #SDTLVWriter,
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDSnapshotWriter class >> typeContext [

	^ 2
]

{ #category : #accessing }
SDSnapshotWriter class >> typeMeta [

	^ 1
]

{ #category : #accessing }
SDSnapshotWriter class >> typeStack [

	^ 3
]

{ #category : #api }
SDSnapshotWriter >> writeContextOf: aSnapshot [
	self
		writeType: self class typeContext
		with: [ :aStream | 
			| serializer |
			serializer := FLSerializer newDefault.
			serializer serialize: aSnapshot context on: stream ]
]

{ #category : #api }
SDSnapshotWriter >> writeMetaOf: aSnapshot [
	self
		writeType: self class typeMeta
		with:
			[ :aStream | aStream nextPutAll: (NeoJSONWriter toString: aSnapshot) utf8Encoded ]
]

{ #category : #api }
SDSnapshotWriter >> writeSnapshot: aSnapshot [

	self writeMetaOf: aSnapshot.
	self writeContextOf: aSnapshot.
	self writeStackTraceOf: aSnapshot
]

{ #category : #api }
SDSnapshotWriter >> writeStackTraceOf: aSnapshot [
	self
		writeType: self class typeStack
		with: [ :aStream | aStream nextPutAll: aSnapshot stackTrace utf8Encoded ]
]
