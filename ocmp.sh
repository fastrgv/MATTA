
# use this to ensure a complete recompilation:
if [ -d ./obj/ ]; then
	rm ./obj/*
else
	mkdir obj
fi


export PATH=$HOME/opt/GNAT/2019/bin:$PATH


gnatmake wav2txt -o wav2txt_osx -D $PWD/obj


