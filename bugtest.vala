Bytes get_bytes() {
	return new Bytes({0,1,2,3});
}

void double_free() {
	string[] vtxshader = {(string)(get_bytes())};
	string[] frgshader = {(string)(get_bytes())};
}

public static int main (string[] args) {
	double_free();
	return 0;
}