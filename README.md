# clipboard-to-epub
Quick and dirty perl script to convert text to epub

## Usage
1. Copy text from a web page into your clipboard. This filters out the html leaving just the text.
1. Paste the clipboard to a text file
1. Pass that text file as the first argument. The output will go to `STDOUT`
```
./convert.pl input.txt
```

## Conversion
* Assumes first line of text is the page title
* Assumes the first line that begins with a footnote is the beginning of a list of footnotes
* Footnote references signified with square brackets will be hyperlinked to list of footnotes
  * For example `A long time ago, in a galaxy a far, far away... [1]`
* Each line in the list of footnotes will link back to the footnote reference
