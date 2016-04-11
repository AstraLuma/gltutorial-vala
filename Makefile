EXTRAFLAGS=$(addprefix --Xcc=,$(shell pkg-config --cflags --libs glew graphene-gobject-1.0) shaders.c -I$(CURDIR))
VALALIBS=--vapidir=. --pkg=gtk+-3.0 --pkg=gl --pkg=glew --pkg=gio-2.0 --pkg=resource --pkg=graphene-1.0 --save-temps

gltest : *.vala *.vapi shaders.c shaders.h
	valac --debug --thread --output=$@ ${VALALIBS} --gresources shaders.gresouce.xml ${EXTRAFLAGS} $(filter %.vala,$^)

#%.c : %.vala
#	valac --debug --thread -C --output=$@ ${VALALIBS} --gresources shaders.gresouce.xml ${EXTRAFLAGS} $(filter %.vala,$^)

%.c %.h : %.gresource.xml $(shell glib-compile-resources --generate-dependencies *.gresource.xml)
	glib-compile-resources --target=$@ --generate $<

.PHONY : clean
clean :
	git clean -xf