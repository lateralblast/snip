![SNIP](https://raw.githubusercontent.com/lateralblast/snip/master/snip.jpg)

SNIP
====

Service Now Information Processor

Information
-----------

Processes a Service Now XLSX CMDB extract and reports data quality problems.

The extract must have these columns, in this order:

Name, Class, Short description, Manufacturer, Location, OS Service Pack, OS Version, OS Address Width (bits), OS Domain, Operating System, Operational status

All worksheets are processed. Empty rows and header rows are skipped.

Checks
------

For each host, the following are reported if found:

- A description in the Hostname field (e.g. `host01 - web server`)
- No environment information (Dev / Prod / Test) in the name, description, location or domain
- No OS name
- No OS version
- No OS revision (service pack)
- No operational status (operational / decom)

Version
-------

Current version: 0.1.5

Requirements
------------

Perl modules (listed in `cpanfile`):

- Spreadsheet::XLSX
- Text::Iconv
- Getopt::Std (core)

Missing modules are installed automatically into `~/perl5` on first run using `cpan`.
To install them manually: `cpanm --installdeps .`

Usage
-----

```
$ snip.pl -h

Usage: snip.pl -chVi:

-h: Display help/usage
-V: Display version
-c: Check CMDB data
-i: Input file (Default ./cmdb.xlsx)
```

Examples
--------

Check CMDB extract:

```
$ snip.pl -c -i CMDB.xlsx
```

Example output:

```
host01 contains a description in the Hostname field
host01 does not contain any environment information (e.g. Dev / Prod / Test)
host02 does not contain any OS version information
```

License
-------

This software is licensed as CC BY-NC-SA (Creative Commons Attribution-NonCommercial-ShareAlike 4.0).

https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

Help Support Development
------------------------

If you find this software useful and would like to support its development, please consider buying me a coffee:

https://ko-fi.com/richardatlateralblast
