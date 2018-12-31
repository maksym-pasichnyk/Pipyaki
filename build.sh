rm -rf ./out/* ./build/game.love
mkdir -p out
mkdir -p build

for file in $(find . -iname "*.lua") ; do
    mkdir -p out/$(dirname "${file}")
    luajit -b ${file} out/${file}
done

zip -q -9 -r build/game.love assets/
cd out && zip -q -9 -r ../build/game.love * && cd ..