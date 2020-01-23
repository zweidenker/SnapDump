Class {
	#name : #SDSnapshotReader,
	#superclass : #SDTLReader,
	#category : #'SnapDump-Core'
}

{ #category : #api }
SDSnapshotReader >> readContext [

	^  FLMaterializer materializeFromByteArray: (self readType: SDSnapshotWriter typeContext)
]

{ #category : #api }
SDSnapshotReader >> readMeta [

	^  NeoJSONReader fromString: (self readType: SDSnapshotWriter typeMeta) utf8Decoded
]

{ #category : #api }
SDSnapshotReader >> readStack [

	^ (self readType: SDSnapshotWriter typeStack) utf8Decoded
]
