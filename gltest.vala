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

	static const GLfloat g_vertex_buffer_data[] = {
		-1.0f, -1.0f, 0.0f,
		1.0f, -1.0f, 0.0f,
		0.0f,  1.0f, 0.0f,
	};

	static const ulong sizeof__g_vertex_buffer_data = sizeof(GLfloat) * 9;

	private GLuint[] vtxary = {-1};
	private GLuint[] vtxbuf = {-1};

	private void init_render() {
		glewExperimental = GL_TRUE; 
		glewInit();

		glGenVertexArrays(1, vtxary);
		glBindVertexArray(vtxary[0]);

		
		// Generate 1 buffer, put the resulting identifier in vtxbuf
		glGenBuffers(1, vtxbuf);
		glBindBuffer(GL_ARRAY_BUFFER, vtxbuf[0]);
		// Give our vertices to OpenGL.
		glBufferData(GL_ARRAY_BUFFER, sizeof__g_vertex_buffer_data, (GLvoid[]?)g_vertex_buffer_data, GL_STATIC_DRAW);

		load_shaders("/com/astro73/Spacers/vertex.glsl", "/com/astro73/Spacers/fragment.glsl");

		first = false;
	}

	private void load_shaders(string vertex_name, string fragment_name) throws GLib.Error {
		GLuint VertexShaderID = glCreateShader(GL_VERTEX_SHADER);
		GLuint FragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);

		string[] vtxshader = {(string)(Shaders.get_resource().lookup_data(vertex_name, ResourceLookupFlags.NONE))};
		string[] frgshader = {(string)(Shaders.get_resour`ce().lookup_data(vertex_name, ResourceLookupFlags.NONE))};

		stdout.printf("Compiling shader : %s\n", vertex_name);
		glShaderSource(VertexShaderID, 1, vtxshader, null);
		glCompileShader(VertexShaderID);

		GLint[] Result = {GL_FALSE};
		int[] InfoLogLength = {0};
		glGetShaderiv(VertexShaderID, GL_COMPILE_STATUS, Result);
		glGetShaderiv(VertexShaderID, GL_INFO_LOG_LENGTH, InfoLogLength);
		if ( InfoLogLength[0] > 0 ){
			ByteArray VertexShaderErrorMessage = new ByteArray.sized(InfoLogLength[0]+1);
			glGetShaderInfoLog(VertexShaderID, InfoLogLength[0], null, VertexShaderErrorMessage.data);
			stderr.printf("%s\n", (string)VertexShaderErrorMessage.data);
		}

	}

	private bool renderframe(GLContext ctx) {
		if (first) init_render();

		// 1rst attribute buffer : vertices
		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, vtxbuf[0]);
		glVertexAttribPointer(
		   0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
		   3,                  // size
		   GL_FLOAT,           // type
		   GL_FALSE,           // normalized?
		   0,                  // stride
		   (GLvoid[])0            // array buffer offset
		);
		// Draw the triangle !
		glDrawArrays(GL_TRIANGLES, 0, 3); // Starting from vertex 0; 3 vertices total -> 1 triangle
		glDisableVertexAttribArray(0);
		return false;
	}
}

public static int main (string[] args) {
	Gtk.init (ref args);

	AppWindow app = new AppWindow();
	app.show_all();
	Gtk.main();
	return 0;
}