using Gtk;
using GL;
using Gdk;

class AppWindow : Gtk.Window {
	public GLArea glarea {get; construct;}

	private bool first = true;

	construct {
		glarea = new GLArea();
		add(glarea);

		glarea.render.connect(renderframe);

		destroy.connect (() => {
			Gtk.main_quit ();
		});
	}

	private bool renderframe(GLContext ctx) {
		if (first) init_render();

		return false;
	}

	private void init_render() {
		glewExperimental = GL_TRUE; 
		glewInit();

		GLuint[1] vtxbuf = {-1};
		glGenVertexArrays(1, vtxbuf);
		glBindVertexArray(vtxbuf[0]);

		first = false;
	}
}

public static int main (string[] args) {
	Gtk.init (ref args);

	AppWindow app = new AppWindow();
	app.show_all();
	Gtk.main();
	return 0;
}