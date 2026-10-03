![alt tag](https://raw.githubusercontent.com/lateralblast/snip/master/snip.jpg)

SNIP
====

Service Now Information Processor

Information
-----------

Processes a Service Now XLSX CMDB extract

License
-------

This software is licensed as CC BY-NC-SA (Creative Commons Attribution-NonCommercial-ShareAlike 4.0)

https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

Usage
-----

```
$ snip.pl -h

-h: Display help/usage
-V: Display version
-c: Check CMDB data
-i: Input file (Default ./cmdb.xlsx)
```

Examples
--------

Check CMDB extract

```
$ snip.pl -c -i CMDB.xlsx
```

Requirements
------------

Perl Modules:

- use Spreadsheet::XLSX
- Getopt::Std
- Text::Iconv


Help Support Development
------------------------

If you find this software useful and would like to support its development, please consider buying me a coffee:

https://ko-fi.com/richardatlateralblast
