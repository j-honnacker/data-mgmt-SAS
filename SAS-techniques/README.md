## SAS Techniques

### Purpose

Whenever I needed a refresher on how hashes work, [Hash_Basics.sas](https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Hash_Basics.sas "Hash_Basics.sas") can help me out. If I thought about using a more complex "hash of hashes" approach (because it's fancy) but wasn't sure if it was a good solution for the issue at hand (often it's not), [Hash_Hash-of-Hashes.sas](https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Hash_Hash-of-Hashes.sas "Hash_Hash-of-Hashes.sas") demonstrates *the technique* **and** contains *an issue* which can be adequately solved by it.


### Overview

<table>

<thead>
<tr>
<th align="left">File</th>
<th align="left">Content</th>
</tr>
</thead>

<tbody>

<!-- DI-Studio_Formats.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/DI-Studio_Formats.sas">
DI-Studio_Formats.sas
</a></code>
</td>

<td align="left">
shows a way to run <i>Data Integration Studio</i> jobs that require additional formats <a href="#DI-Studio_Formats">Details</a>
</td>
</tr>


<!-- Formats_Numeric.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Formats_Numeric.sas">
Formats_Numeric.sas
</a></code>
</td>

<td align="left">
applies formats to numeric variables
</td>
</tr>


<!-- Formats_Transformations.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Formats_Transformations.sas">
Formats_Transformations.sas
</a></code>
</td>

<td align="left">
transforms the value of one variable to an equivalent value of another variable using Formats/Informats
</td>
</tr>


<!-- Hash_Basics.sas --> 
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Hash_Basics.sas">
Hash_Basics.sas
</a></code>
</td>

<td align="left">
explains the basics of initiating, populating and iterating through hash tables
</td>
</tr>


<!-- Hash_Hash-of-Hashes.sas --> 
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Hash_Hash-of-Hashes.sas">
Hash_Hash&#8209;of&#8209;Hashes.sas
</a></code>
</td>

<td align="left">
illustrates "Hash of Hashes" by an appropriate use case example
</td>

</tr>


<!-- MacroL_Loops.sas --> 
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/MacroL_Loops.sas">
MacroL_Loops.sas
</a></code>
</td>

<td align="left">
demonstrates how to iterate through monthly/daily data sets using timestamps
</td>

</tr>


<!-- MacroL_Loops.sa --> 
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/MacroL_Ways-to-create-MacroVars.sas">
MacroL_Ways&#8209;to&#8209;create&#8209;MacroVars.sas
</a></code>
</td>

<td align="left">
applies different approaches to create macro variables
</td>

</tr>


<!-- ReadCSV_Find-and-Replace-Dates.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/ReadCSV_Line-Breaks-within-Quotes.sas">
ReadCSV_Line&#8209;Breaks&#8209;within&#8209;Quotes.sas
</a></code>
</td>

<td align="left">
reads a CSV without starting a new record when encountering line breaks within quotes
</td>

</tr>


<!-- ReadCSV_NAs.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/ReadCSV_NAs.sas">
 ReadCSV_NAs.sas
</a></code>
</td>

<td align="left">
reads a CSV and recognizes "NA" values as missing values for both character and numeric variables <a href="#ReadCSV-NAs">Details</a>
</td>

</tr>


<!-- ReadCSV_Simulate-External-File.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/ReadCSV_Simulate-External-File.sas">
ReadCSV_Simulate&#8209;External&#8209;File.sas
</a></code>
</td>

<td align="left">
demonstrates how to read instream data which can be used to simulate an external file
</td>

</tr>


<!-- RegEx_Find-and-Replace-Dates.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/RegEx_Find-and-Replace-Dates.sas">
RegEx_Find-and-Replace-Dates.sas
</a></code>
</td>

<td align="left">
describes how to identify and overwrite the date portion of a string
</td>

</tr>


<!-- Views_Basics.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Views_Basics.sas">
Views_Basics.sas
</a></code>
</td>

<td align="left">
showcases different view techniques (in-line, DATA step, SQL) on example data
</td>

</tr>


<!-- Views_Beyond-Basics.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/Views_Beyond-Basics.sas">
Views_Beyond&#8209;Basics.sas
</code></a>
</td>

<td align="left">
covers interesting features related to views that I've stumbled across in practice
(e.g., defining both <i>data set</i> and <i>view</i> in one DATA step, using macro variables in view definitions)
</td>

</tr>


<!-- sas7bdat_Delete-Data-Sets.sas -->
<tr>

<td align="left">
<code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/sas7bdat_Delete-Data-Sets.sas">
sas7bdat_Delete&#8209;Data&#8209;Sets.sas
</code></a>
</td>

<td align="left">
demonstrates different ways (PROC DATASETS/DELETE, PROC SQL) to delete SAS data sets
</td>

</tr>

</tbody>

</table>


<a id='DI-Studio_Formats'></a>
### <code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/DI-Studio_Formats.sas">DI-Studio_Formats.sas</a></code>

<img src="https://github.com/j-honnacker/data-mgmt-SAS/blob/README/DI-Studio_Precode.PNG" alt="Precode tab of a DI Studio job" width="600"/>


<a id='ReadCSV-NAs'></a>
### <code><a target="_blank" rel="noopener noreferrer" href="https://github.com/j-honnacker/data-mgmt-SAS/blob/master/SAS-techniques/ReadCSV_NAs.sas">ReadCSV_NAs.sas</a></code>

This example shows how to import a CSV file into SAS that contains missing values which are represented by "NA". This placeholder mainly occured in CSV files I received from departments working with R.

Since SAS requires missing values to be represented by blanks (or single periods), the following approach reads the original CSV file and creates a temporary copy of it in which NAs are replaced by blanks. The final import step then uses this pre-processed copy instead of the original file.
