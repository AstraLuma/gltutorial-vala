[CCode (cprefix = "GL", gir_namespace = "GLEW", gir_version = "1.0", lower_case_cprefix = "gl_")]
namespace GL {
	[CCode (cheader_filename = "GL/glew.h", cname = "glewInit")]
	public static void /* GLenum GLEWAPIENTRY */ glewInit();

	[CCode (cheader_filename = "GL/glew.h", cname = "glewExperimental")]
	public static /*GL.GLboolean*/ int glewExperimental;
}