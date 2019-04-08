rm -rf build
mkdir -p build/out

for file in $(find . -iname "*.lua") ; do
    mkdir -p build/out/$(dirname "${file}")
    # luajit -b ${file} build/out/${file}
    cp -rf ${file} build/out/${file}
done

zip -q -9 -r build/game.love assets/
cd build/out
zip -q -9 -r ../game.love * 
cd ../..

mkdir -p app/assets
cp -rf build/game.love app/assets/game.love
cp -rf game/AndroidManifest.xml app/AndroidManifest.xml
cp -rf game/res app
apktool b -o build/game-unsigned.apk app

java -jar uber-apk-signer.jar --apks build/game-unsigned.apk --ks maxim.keystore --ksAlias jinsei