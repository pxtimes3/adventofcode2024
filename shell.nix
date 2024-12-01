{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
	buildInputs = with pkgs; [
		lua5_4_compat     # Using Lua 5.4 instead of 5.2
		lua54Packages.luacheck  # For linting
		luarocks

		# Common development tools
		gcc
		gnumake

		# Optional but useful Lua tools
		selene # A Lua linter
		stylua # Lua formatter

		# If you need LuaJIT FFI development
		pkg-config
	];

	shellHook = ''
		echo "Lua development environment loaded!"
		echo "Lua version: $(lua -v)"
		echo "LuaRocks version: $(luarocks --version)"
	'';
}
