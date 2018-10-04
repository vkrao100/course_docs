str_png=.png
for file in *.dot; do
	png_file="${file/.dot/$str_png}"
	dot -Tpng $file > $png_file
done

