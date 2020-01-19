cd src/content/
python md_merger.py
cd ../../
npm run build
echo "$(date +%F@%T)" > build/timestamp 
