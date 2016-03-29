EXTRAFLAGS=$(addprefix --Xcc=,$(shell pkg-config --cflags --libs glew))

gltest : gltest.vala gl.vapi
	valac --debug --thread --vapidir=. --pkg=gtk+-3.0 --pkg=gl --pkg=glew --output=$@ ${EXTRAFLAGS} $<
