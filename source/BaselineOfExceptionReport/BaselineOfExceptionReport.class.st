Class {
	#name : #BaselineOfExceptionReport,
	#superclass : #BaselineOf,
	#category : 'BaselineOfExceptionReport'
}

{ #category : #baselines }
BaselineOfExceptionReport >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec package: #'ExceptionReport-Core'.
		spec package: #'ExceptionReport-Rest' with: [ spec requires: #('ExceptionReport-Core' 'ZincHTTPComponents' ) ].
		spec baseline: 'ZincHTTPComponents' with: [ 
				spec 
					loads: #('REST');
					repository: 'github://zweidenker/zinc/repository'].
		spec 
			group: 'default' with: #(#'ExceptionReport-Core' );
			group: 'REST' with: #( #'ExceptionReport-Rest' );
			group: 'core' with: #(#'ExceptionReport-Core' ) ].

]
