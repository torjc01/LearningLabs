colorful is a simple Atari 2600 program that shows off moving bands of color.

Use dasm to compile the program.  Dasm can be found here:
http://dasm-dillon.sourceforge.net

The command used to compile is:
dasm colorful.asm -f3 -v0 -scolorful.sym -lcolorful.lst -ocolorful.bin


the options after the source file are:
    -f3 sets output format to 3, RAW.

    -v0 sets verboseness, not required.  Values are 0-4, see dasm documentation.

    -s requests a symbol dump, saved to specified file.

    -l requests a detailed listing, saved to specified file.

    -o specifies the output file.  If not specified, the output file will be a.out

Only option -f3 is required for Atari 2600 programs.
