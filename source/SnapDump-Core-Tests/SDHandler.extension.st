Extension { #name : #SDHandler }

{ #category : #'*SnapDump-Core-Tests' }
SDHandler class >> fillExamples [
	| handler |
	handler := SDHandler new
		store: SnapDump current store.

1 to: 2 do: [:x| | snapshot |
	1 to: 2 do: [ :y |
		1 to: 2 do: [ :z |  
	handler 
		projectName: ('projectname', x asString) 
		versionString: '1.', y asString.
	snapshot := SDTests new dummyContext asSnapshot
		projectName: handler project;
		versionString: (handler version).
	"snapshot id: (snapshot id at: snapshot id size atRandom put: Character alphabet atRandom; yourself)".
	handler handleSnapshot: snapshot ] ] ]
]
