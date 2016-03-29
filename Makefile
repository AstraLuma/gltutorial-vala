EXTRAFLAGS=$(addprefix --Xcc=,$(shell pkg-config --cflags --libs glew))

gltest : gltest.vala gl.vapi
	valac --debug --thread --vapidir=. --pkg=gtk+-3.0 --pkg=gl --pkg=glew --output=$@ ${EXTRAFLAGS} $<

gles2.vapi :
	wget https://raw.githubusercontent.com/nemequ/vala-extra-vapis/master/gles2.vapi -O $@

gl.vapi :
	wget https://github.com/lucidfox/valagl/raw/master/vapi/gl.vapi -O $@
