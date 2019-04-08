rm -rf build
mkdir -p build/out

for file in $(find . -iname "*.lua") ; do
    mkdir -p build/out/$(dirname "${file}")
    luajit -b ${file} build/out/${file}
done

zip -q -9 -r build/game.love assets/
cd build/out
zip -q -9 -r ../game.love * 
cd ../..