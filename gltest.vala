using Gtk;
using GL;
using Gdk;

errordomain GLCompileError {
	SHADER,
	PROGRAM
}

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

	private GLuint vertexarray = -1;
	private GLuint vertexbuffer = -1;

	private void init_render() {
		glewExperimental = GL_TRUE; 
		glewInit();

		GLuint[1] vtxary = {vertexarray};
		GLuint[1] vtxbuf = {vertexbuffer};

		glGenVertexArrays(1, vtxary);
		vertexarray = vtxary[0];
		glBindVertexArray(vertexarray);

		
		// Generate 1 buffer, put the resulting identifier in vtxbuf
		glGenBuffers(1, vtxbuf);
		vertexbuffer = vtxbuf[0];
		glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
		// Give our vertices to OpenGL.
		glBufferData(GL_ARRAY_BUFFER, sizeof__g_vertex_buffer_data, (GLvoid[]?)g_vertex_buffer_data, GL_STATIC_DRAW);

		load_shaders("/com/astro73/Spacers/vertex.glsl", "/com/astro73/Spacers/fragment.glsl");

		first = false;
	}

	private GLuint load_shaders(string vertex_name, string fragment_name) throws GLib.Error, GLCompileError {
		stdout.printf("Compiling vertex shader : %s\n", vertex_name);
		GLuint VertexShaderID = compile_shader(GL_VERTEX_SHADER, vertex_name);

		stdout.printf("Compiling fragment shader : %s\n", fragment_name);
		GLuint FragmentShaderID = compile_shader(GL_FRAGMENT_SHADER, fragment_name);

		stdout.printf("Linking program\n");

		GLuint ProgramID = glCreateProgram();
		glAttachShader(ProgramID, VertexShaderID);
		glAttachShader(ProgramID, FragmentShaderID);
		glLinkProgram(ProgramID);
		GLint[] Results = {-1};
		int[] InfoLogLength = {-1};
		glGetProgramiv(ProgramID, GL_LINK_STATUS, Results);
		glGetProgramiv(ProgramID, GL_INFO_LOG_LENGTH, InfoLogLength);
		if ( InfoLogLength[0] > 0 ){
			ByteArray infobuf = new ByteArray.sized(InfoLogLength[0]+1);
			glGetProgramInfoLog(ProgramID, InfoLogLength[0], null, infobuf.data);
			string infolog = (string)infobuf.data;
			stderr.printf("Error: %s\n", infolog);
			throw new GLCompileError.PROGRAM(infolog);
		}

		glDetachShader(ProgramID, VertexShaderID);
		glDetachShader(ProgramID, FragmentShaderID);
		
		glDeleteShader(VertexShaderID);
		glDeleteShader(FragmentShaderID);

		return ProgramID;
	}

	private GLuint compile_shader(GL.GLenum type, string resource) throws GLib.Error, GLCompileError {
		GLuint shid = glCreateShader(type);

		Resource r = Shaders.get_resource();

		string[] vtxshader = {(string)(r.lookup_data(resource, ResourceLookupFlags.NONE).get_data())};

		GLint[] Results = {-1};
		int[] InfoLogLength = {-1};
		glGetShaderiv(shid, GL_COMPILE_STATUS, Results);
		glGetShaderiv(shid, GL_INFO_LOG_LENGTH, InfoLogLength);
		stderr.printf("%i %i\n", Results[0], InfoLogLength[0]);
		if (Results[0] != GL_TRUE) {
			string infolog = "";
			if ( InfoLogLength[0] > 0 ){
				ByteArray infobuffer = new ByteArray.sized(InfoLogLength[0]+1);
				glGetShaderInfoLog(shid, InfoLogLength[0], null, infobuffer.data);
				infolog = (string)infobuffer.data;
			}
			throw new GLCompileError.SHADER(infolog);
		}			

		return shid;
	}

	private bool renderframe(GLContext ctx) {
		if (first) init_render();

		// 1rst attribute buffer : vertices
		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
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