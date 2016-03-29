gltest : gltest.vala gles2.vapi
	valac --debug --thread --vapidir=. --pkg=gtk+-3.0 --pkg=gles2 $< --output=$@

gles2.vapi :
	wget https://raw.githubusercontent.com/nemequ/vala-extra-vapis/master/gles2.vapi -O $@