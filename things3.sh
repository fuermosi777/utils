echo "Free Things 3"
echo "Removing current Thing 3 and its files..."

osascript -e 'quit app "things"'

rm -rf /Applications/Things3.app
rm -rf ~/Library/Caches/com.culturedcode.ThingsMac
rm -rf ~/Library/Containers/com.culturedcode.ThingsMac
rm -rf ~/Library/Preferences/com.culturedcode.ThingsMac.plist

echo "Downloading new Things 3 from the website"
curl https://static.culturedcode.com/things/Things3.zip -o ~/Desktop/Things3.zip

echo "Unzipping..."
unzip -o ~/Desktop/Things3.zip -d ~/Desktop

echo "Moving to Application folder and delete zip file..."
mv ~/Desktop/Things3.app /Applications/
rm -rf ~/Desktop/Things3.zip

echo "Done!"
open -a Things3
