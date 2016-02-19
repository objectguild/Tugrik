private
asLocalFloatObj: number
"SmallDouble"
	| efBits sign newFloat result expBits |
	efBits := number >> 4. "(OOP_NUM_TAG_BITS + 1)"
	sign := number bitAnd: 16r8.
	result := 0.
	(efBits == 0)
		ifTrue: [^0.0].
	expBits := number >> 56.
	result := (number << 8) >> 12. "isolate f bits"
	expBits := expBits + 16r380. "SMALL_DOUBLE_EXPONENT_BASE"
	result := result bitOr: (expBits << 52).
	result := result bitOr: (sign << 60).
	newFloat := Float new: 2.
	newFloat basicAt: 1 put: (result >> 32).
	newFloat basicAt: 2 put: (result bitAnd: 16rFFFFFFFF).
	^newFloat