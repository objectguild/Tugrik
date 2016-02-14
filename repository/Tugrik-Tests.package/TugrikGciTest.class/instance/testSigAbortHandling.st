tests
testSigAbortHandling
	| session1 session2 oldStnSigAbortCrBacklog count limit |
	session1 := TugricGciSession login: GciSessionDescription example.
	session2 := TugricGciSession login: GciSessionDescription example.
	[ 
	| oopType |
	oldStnSigAbortCrBacklog := (session1 executeString: 'System stoneConfigurationAt: #StnSignalAbortCrBacklog')
		asLocalObjectFor: session1.
	oopType := session1
		executeString:
			'System stoneConfigurationAt: #StnSignalAbortCrBacklog put: 10.
	System enableSignaledFinishTransactionError'.
	oopType := session2 executeString: 'System enableSignaledFinishTransactionError'.
	count := 0.
	limit := 20.
	[ count < limit ]
		whileTrue: [ 
			session1 executeString: 'UserGlobals at:#''TUGRIK_TESTING'' put:Object new. System commit'.
			(Delay forMilliseconds: 50) wait.
			count := count + 1 ].
	session2 pollForSignal
		ifFalse: [ self fail: 'expected a pending SigAbort error' ].
	session2 gciError ]
		ensure: [ 
			session1
				executeString: 'System stoneConfigurationAt: #StnSignalAbortCrBacklog put: ' , oldStnSigAbortCrBacklog printString.
			session1 executeString: 'UserGlobals removeKey:#''TUGRIK_TESTING'' ifAbsent:[]. System commit'.
			session1 logout.
			session2 logout ]