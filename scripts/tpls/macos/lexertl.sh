if [ ! -d lexertl14 ]; then
	git clone https://github.com/BenHanson/lexertl14 lexertl14
fi

echo installing lexertl14...
if [ -d $TPLS_HOME/lexertl14 ]; then
rm -rf $TPLS_HOME/lexertl14
fi

mkdir -p $TPLS_HOME/lexertl14
cp -r lexertl14/include $TPLS_HOME/lexertl14/include
