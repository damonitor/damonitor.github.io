#!/bin/bash

#!/bin/bash

INDEX_FILE='_index.html'

echo "
<pre>
Git Branches and Patchsets
==========================

Development of DAMON is mainly done in 'damon/next' branch of sj's Linux kernel
git tree (https://github.com/sjp38/linux).  The commits for DAMON on the
branch, which is based on a upstream kernel, are periodically rebased and
grouped into three different parts of DAMON, organized as normal patchsets, and
posted to LKML if necessary.

The three patchsets are:
- DAMON: The core monitoring part,
- DAMOS: DAMON-based Operation Schemes, implemented on DAMON, and
- CDAMON: Configurable DAMON, implemented on DAMOS.

For each posting of any patchset, 'damon/master' is updated to point the latest
commit of 'damon/next', and 'damon/next' continues development.


Documents
=========

The documents under 'doc/html/' in this site are organized in below way.

- 'latest' is the document for the 'damon/master'.
- 'latest-(damon|damos)' are the documents for the DAMON or DAMOS patchset,
  made by 'damon/master'.
- 'next' is the document for the 'damon/next'.
- 'next-(damon|damos)' are similar to 'doc/html/latest-(damon|damos)'
- 'v13' is the document for the 'damon/master' when 'v13' of DAMON patchset is
  posted.
- 'v13-(damon|damos)' are similar in that way.
</pre>
" > $INDEX_FILE

for f in `find doc -maxdepth 3 -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done

echo "
<pre>

Test Results
============

The correctness / performance tests are done against 'damon/master' for major
changes.  Therefore, version name rules that similar to that of documents are
applied to the test results in this site, but '(damon|damos)' suffixes are not
used.
</pre>
" >> $INDEX_FILE

for f in `find test -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done
