pin:	lex.yy.c y.tab.c
	gcc -o pin lex.yy.c y.tab.c

lex.yy.c:	y.tab.c pin.l
		lex pin.l

y.tab.c:	pin.y
		yacc -d pin.y

clean:	rm -rf lex.yy.c y.tab.c y.tab.h
