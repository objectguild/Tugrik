gci api
executeAndFetchResultAsUtf8EncodedString: utf8EncodedResultString sourceString: sourceString sourceOopType: sourceOopType contextOopType: contextOopType symbolListOopType: symbolListOopType 
	| aGciTs32xErrSType result  |
	aGciTs32xErrSType := GciTs32xErrSType new.
	result := self gciLibrary
		apiGciTsExecuteFetchBytes: self gciSession
		a: sourceString
		a: sourceString size
		a: sourceOopType
		a: contextOopType
		a: symbolListOopType
		a: utf8EncodedResultString
		a: utf8EncodedResultString size
		a: aGciTs32xErrSType.
	result = -1
		ifTrue: [ self gciError: aGciTs32xErrSType ].
	^ true