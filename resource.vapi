[CCode (cprefix = "Shaders", lower_case_cprefix = "shaders_")]
namespace Shaders {
	[CCode (cheader_filename = "shaders.h")]
	public static GLib.Resource get_resource();
}