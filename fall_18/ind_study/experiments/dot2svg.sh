str_svg=.svg
for file in *.dot; do
	svg_file="${file/.dot/$str_svg}"
	dot -Tsvg $file > $svg_file
done

