Class {
	#name : 'SDFileSnapshot',
	#superclass : 'SDSnapshot',
	#instVars : [
		'file'
	],
	#category : 'SnapDump-Core-Model',
	#package : 'SnapDump-Core',
	#tag : 'Model'
}

{ #category : 'accessing' }
SDFileSnapshot >> file: aFileReference [ 
	file := aFileReference 
]

{ #category : 'as yet unclassified' }
SDFileSnapshot >> fileSize [
	^ file size
]

{ #category : 'options' }
SDFileSnapshot >> newReader [ 
	^ SDSnapshotFileReader file: file
]

{ #category : 'as yet unclassified' }
SDFileSnapshot >> storeRaw: aByteArray [

	file binaryWriteStream 
		nextPutAll: aByteArray;  
		close
]
