using Gtk;
using GLES2;

class AppWindow : Window {
	GLArea glarea {get; set;}

	construct {
		glarea = new GLArea();
		add(glarea);

		destroy.connect (() => {
			Gtk.main_quit ();
		});
	}
}

public static int main (string[] args) {
	Gtk.init (ref args);

	AppWindow app = new AppWindow();
	app.show_all();
	Gtk.main();
	return 0;
}