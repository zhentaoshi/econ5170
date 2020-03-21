
quantmod::getSymbols("AAPL",  src = "yahoo") # from = "2017-01-01", to = Sys.Date(),

print( tail(AAPL) )

N_AAPL = nrow(AAPL)
AAPL100 = AAPL$AAPL.Close[(N_AAPL - 100): N_AAPL  ]

quantmod::getSymbols("^GSPC",  src = "yahoo") # from = "2017-01-01", to = Sys.Date(),

print( tail(GSPC))
N_GSPC = nrow(GSPC)
GSPC100 = GSPC$GSPC.Close[(N_GSPC - 100): N_GSPC  ]

reg = lm( AAPL100 ~ GSPC100)
print( coef(reg) )
