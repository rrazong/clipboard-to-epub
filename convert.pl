#! /usr/bin/perl -w
use strict;
use constant false => 0;
use constant true => 1;

my $filename = shift;
open(INPUT, $filename) or die "Could not open $filename";

my $titleFound = false;
my $footnoteMode = false;
my $footnoteCount = 1;

while(my $line = <INPUT>) {
  next if ($line =~ /^\s*$/);
  chomp $line;

  # Assume first line of text is the page title
  if (false == $titleFound) {
    $titleFound = true;
    print <<"HERE";
<?xml version='1.0' encoding='utf-8'?>
<html xmlns:epub="http://www.idpf.org/2007/ops" xmlns:pls="http://www.w3.org/2005/01/pronunciation-lexicon" xmlns:ssml="http://www.w3.org/2001/10/synthesis" xmlns="http://www.w3.org/1999/xhtml" xmlnsU0003Am="http://www.w3.org/1998/Math/MathML" xmlnsU0003Asvg="http://www.w3.org/2000/svg">

<head>
  <title>$line</title>
  <link rel="stylesheet" type="text/css" href="style.css"/>
</head>

<body>

  <h1>$line</h1>

HERE
    next;
  }

  # Check if footnote section has begun
  if ($line =~ /^\[\d+\]/ && false == $footnoteMode) {
    $footnoteMode = true;
    print "<div class=\"footnotes\">\n";
  }

  # Check for footnote
  if ($line =~ /^\[/ && $footnoteMode) {
    print <<"HERE";
  <aside id="footnote$footnoteCount" epub:type="footnote">
    <p>
      $line
      <a href="#footnote$footnoteCount-ref">↩</a>
    </p>
  </aside>
HERE
    $footnoteCount++;
    next;
  }

  # Check for heading
  # If the line does not have at least one period, then it is a heading.
  if ($line !~ /\./) {
    print <<"HERE";
  <h3>$line</h3>

HERE
  } else {
    # Found a paragraph
    $line = "<p>$line</p>\n";

    # Add footnote link
    $line =~ s/\[(\d{1,2})\]/[<a id="footnote$1-ref" href="#footnote$1" epub:type="noteref">$1<\/a>]/g;

    print <<"HERE";
  $line
HERE
  }
}

if ($footnoteMode) {
  $footnoteMode = false;
  print "</div>\n";
}

print <<"HERE";
</body>

</html>
HERE

close(INPUT);
