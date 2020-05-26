#!/bin/bash

#!/bin/bash

INDEX_FILE='_index.html'

echo "
<pre>
DAMON Git Branch Rules
======================

Development of DAMON is mainly done in 'damon/next' branch of sj's Linux kernel
git tree (https://github.com/sjp38/linux).  The commits for DAMON, which is
made on the mainline kernel, are grouped into three different parts of DAMON,
organized as normal patchsets, and posted to LKML if necessary.

The three patchsets are:
- DAMON: The core monitoring part,
- DAMOS: DAMON-based Operation Schemes, implemented on DAMON, and
- CDAMON: Configurable DAMON, implemented on DAMOS.

For each posting of any patchset, 'damon/master' is updated to point the latest
commit of 'damon/next', and 'damon/next' continues development.

Documents Organization
======================

The documents are organized in below way.

- 'doc/html/latest' is the document for the 'damon/master'.
- 'doc/html/latest-(damon|damos)' are the documents for the DAMON or DAMOS
  patchset, made by 'damon/master'.
- 'doc/html/next' is the document for the 'damon/next'.
- 'doc/html/next-(damon|damos)' are similar to 'doc/html/latest-(damon|damos)'
- 'doc/html/v13' is the document for the 'damon/master' when 'v13' of DAMON
  patchset is posted.
- 'doc/html/v13-(damon|damos)' are similar in that way.

This site contains the html documentations and test results of DAMON.


Test Result Organization
========================

Tests are done against 'damon/master' for each post of DAMON patchset.
Therefore, similar version names are applied, but '(damon|damos)' suffixes are
not used.
</pre>
" > $INDEX_FILE

echo '<h3>documentations</h3>' >> $INDEX_FILE

for f in `find doc -maxdepth 3 -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done

echo '<br><br><h3>test results</h3>' >> $INDEX_FILE

for f in `find test -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done
