# Unix-Shell-Script-
Bash-Shell Script (Unix) Project
This is a university project using Unix, dealing with writing commands from a set of requirements and operations on a set of files(Open Data File).

Questions and Requirements:-
You should use bash to develop a script for analyzing and partially automating the evaluation of these documents, which should meet the following requirements:

•Your script should take exactly one command line parameter. This is either the file name of a submitted receipt (named txxxxx, the character string xxxxx
is not the s-number of the author but a random number) or one of the character strings stat, all or plag. All other (including missing) parameters are with a
to reject a meaningful report.

•If the argument is a filename, do a series of tests against that file
executed and points awarded accordingly: ¨

1. Checking whether the shebang is in the first position in the first line. Is this the ¨
case, the receipt gets one point.

2. Determination of the percentage of those lines that contain a comment (in relation to the total number of lines). If it is 10% or more, you get
the document a point.

3. Determination and output of the number of exit statements that are not in a comment line. If at least one statement was found that is not in a comment, the document receives one point.

4. Calling up the document without parameters and determining the return value. If this is not equal to 0, the examinee gets one point.

5. Calling up the receipt with the count parameter. He writes down the result
standard This result should match the correct result (= number of rows
be compared in the bib.csv file). If there is a tie, the examinee gets a point.

Each test should end with a short success/failure message. At the end, please enter the number of points achieved and the maximum number of points that can be achieved.

• If the argument is all, then the above tests should be run on all 89 files. The file names of all documents that do not achieve the full number of points should be output.
•If the argument is stat, then it should be determined and output:
– size and name of the smallest document,
– size and name of the largest document,
– the arithmetic mean of all document sizes.

•If the argument is plag, then all test items should be compared in pairs, i.e. each with each other. All identical files must be listed by name.
Note: the diff command might be useful.

•Your script must never abort or block indefinitely; any Error conditions must be caught by you and handled appropriately. Error messages from the commands you use should be suppressed.

•The running time of all operations must be reasonable (< 10s); the plagiarism check may last thirty seconds.

•Don't forget to provide return values for any form of termination.

•Please avoid the multiple occurrence of similar or identical code blocks by using functions where necessary.

•Please note clearly, comment descriptively and pay attention to orthographic and grammatical correctness.



















